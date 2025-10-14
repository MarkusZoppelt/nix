{ pkgs, user, ... }:
{
  nix.enable = false;
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = 5;
  networking.hostName = "Alyx";

  fonts.packages = with pkgs; [ monaspace ];

  # User configuration for Darwin
  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
  };

  programs.zsh.enable = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    brews = [
      {
        name = "ollama";
        restart_service = "changed";
      }
      {
        name = "syncthing";
        restart_service = "changed";
      }
    ];

    casks = [
      "ghostty"
      "orbstack"
    ];
  };

  system.primaryUser = user;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;

  system.defaults.dock.autohide = true;
  system.defaults.dock.autohide-delay = 0.0;
  system.defaults.dock.autohide-time-modifier = 0.0;

  security.pam.services.sudo_local.touchIdAuth = true;
}
