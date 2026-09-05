{
  pkgs,
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
  };
}
