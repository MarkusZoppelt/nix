{ config, ... }:
{
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
    shellAliases = {
      ll = "ls -l";
    };
  };
}
