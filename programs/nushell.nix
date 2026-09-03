{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.nushell = {
    enable = true;
    package = pkgs.unstable.nushell;
    environmentVariables = config.home.sessionVariables;
    settings = {
      show_banner = false;
      highlight_resolved_externals = true;
      history.max_size = 9999999;
    };
    shellAliases = {
      ll = "ls -l";
    };
    extraConfig =
      let
        linuxInit = lib.optionalString pkgs.stdenv.isLinux ''
          if not (($env.SSH_AUTH_SOCK? | default "") | str starts-with "/tmp/") {
            $env.SSH_AUTH_SOCK = $"($env.HOME)/.1password/agent.sock"
          }
        '';
        darwinInit = lib.optionalString pkgs.stdenv.isDarwin ''
          $env.SSH_AUTH_SOCK = $"($env.HOME)/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
        '';
      in
      linuxInit + darwinInit;
  };
}
