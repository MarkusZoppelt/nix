{ config, lib, ... }:
{
  # External commands otherwise complete as files only. The generated
  # integration also rewrites PATH and defines get-env/set-env/unset-env.
  programs.carapace = {
    enable = true;
    enableNushellIntegration = false;
  };

  programs.nushell = {
    enable = true;
    environmentVariables = config.home.sessionVariables;
    # nu never sources /etc/profile, so login shells miss Nix bins and
    # macOS path_helper entries like /usr/local/bin (OrbStack docker).
    # /run/wrappers/bin must come first: NixOS sudo in sw/bin is not setuid.
    extraEnv = ''
      $env.PATH = (
        [
          "/run/wrappers/bin"
          $"($env.HOME)/.nix-profile/bin"
          $"/etc/profiles/per-user/($env.USER? | default "")/bin"
          "/run/current-system/sw/bin"
          "/nix/var/nix/profiles/default/bin"
          "/usr/local/bin"
          "/usr/local/sbin"
        ]
        ++ $env.PATH
        | uniq
      )

      if ('/opt/homebrew' | path type) == 'dir' {
        $env.HOMEBREW_PREFIX = '/opt/homebrew'
        $env.HOMEBREW_CELLAR = '/opt/homebrew/Cellar'
        $env.HOMEBREW_REPOSITORY = '/opt/homebrew'
        $env.PATH = $env.PATH | prepend [
          '/opt/homebrew/bin'
          '/opt/homebrew/sbin'
        ]
        $env.MANPATH = $env.MANPATH? | prepend '/opt/homebrew/share/man'
        $env.INFOPATH = $env.INFOPATH? | prepend '/opt/homebrew/share/info'
      }
    '';
    settings = {
      show_banner = false;
      highlight_resolved_externals = true;
      history.max_size = 9999999;
    };
    # 0.112 passes a span list positionally. Newer nu passes a record when
    # the closure parameter is named place (nushell #18791).
    extraConfig = ''
      let carapace_completer = {|place|
        let spans = if ($place | describe) =~ "record" { $place.command } else { $place }
        if ($spans | is-empty) or ($spans.0 | is-empty) {
          null
        } else {
          let expanded = scope aliases | where name == $spans.0 | get --optional 0.expansion
          let spans = if $expanded != null {
            $spans | skip 1 | prepend ($expanded | split row " ")
          } else {
            $spans
          }
          try {
            with-env { CARAPACE_LENIENT: "1" } {
              ^${lib.getExe config.programs.carapace.package} $spans.0 nushell ...$spans | from json
            }
          } catch {
            null
          }
        }
      }
      $env.config.completions.external.completer = $carapace_completer
    '';
    shellAliases = {
      ll = "ls -l";
    };
  };
}
