{ pkgs, ... }:
{
  nix.enable = false;
  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = 5;
  environment.systemPackages = import ../packages.nix { inherit pkgs; };
  networking.hostName = "G-Man";

  fonts = {
    packages = with pkgs; [
      monaspace
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    interactiveShellInit = ''
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    '';
  };
  programs.tmux = import ../tmux.nix;
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
