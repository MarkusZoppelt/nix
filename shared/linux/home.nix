{  pkgs, ... }:
{
  nix = {
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  home.username = "mz";
  home.homeDirectory = "/home/mz";
  home.stateVersion = "24.11";
  home.packages = import ../packages.nix { inherit pkgs; };
  home.sessionVariables = {
    EDITOR = "nvim";
    NPM_CONFIG_PREFIX = "$HOME/.npm";
    PATH = "$HOME/.npm/bin:${pkgs.lib.makeSearchPath "bin" [ pkgs.nodejs ]}:$PATH";
  };

  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.fzf.enable = true;
  programs.tmux = import ../tmux.nix;
  fonts.fontconfig.enable = true;
}
