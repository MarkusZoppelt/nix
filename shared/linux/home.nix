{  pkgs, ... }:
let
  packageList = import ./packages.nix { inherit pkgs; };
in
{
  home.username = "mz";
  home.homeDirectory = "/home/mz";
  home.stateVersion = "24.05";

  home.packages = packageList;

  fonts.fontconfig.enable = true;

    # Set up npm so that it installs global packages in the user's home directory
  home.sessionVariables = {
    EDITOR = "nvim";
    NPM_CONFIG_PREFIX = "$HOME/.npm";
    PATH = "$HOME/.npm/bin:${pkgs.lib.makeSearchPath "bin" [ pkgs.nodejs ]}:$PATH";
  };

  programs.fzf.enable = true;
  programs.direnv.enable = true;
  programs.home-manager.enable = true;
}
