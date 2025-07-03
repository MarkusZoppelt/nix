{ pkgs, ... }:
{
  nix.enable = false;
  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = 5;
  environment.systemPackages = import ../shared/packages.nix { inherit pkgs; };
  networking.hostName = "G-Man";

  fonts = import ../shared/fonts.nix { inherit pkgs; };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
  };
  programs.tmux = import ../shared/tmux.nix;
  programs.direnv.enable = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    brews = [
      {
        name = "yubikey-agent";
        restart_service = "changed";
      }
      {
        name = "syncthing";
        restart_service = "changed";
      }
    ];

    casks = [
      "signal"
    ];
  };

  system.primaryUser = "mz";
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  
  system.defaults.dock.autohide = true;
  system.defaults.dock.autohide-delay = 0.0;
  system.defaults.dock.autohide-time-modifier = 0.0;

  security.pam.services.sudo_local.touchIdAuth = true;
}
