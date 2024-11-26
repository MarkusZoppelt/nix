{  pkgs, ... }:
let
  packageList = import ./packages.nix { inherit pkgs; };
in
{
  programs.home-manager.enable = true;

  home.username = "mz";
  home.homeDirectory = "/home/mz";
  home.stateVersion = "24.05";

  home.packages = packageList;

  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    NPM_CONFIG_PREFIX = "$HOME/.npm";
    PATH = "$HOME/.npm/bin:${pkgs.lib.makeSearchPath "bin" [ pkgs.nodejs ]}:$PATH";
  };

  programs.fzf.enable = true;
}
