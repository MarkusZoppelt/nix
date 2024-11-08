{ pkgs, ... }:
{
  system.stateVersion = 5;
  environment.systemPackages = with pkgs; [
    mas
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    taps = [
      "homebrew/services"
    ];

    brews = [
      "bazelisk"
      "cmake"
      "lcov"
      "llvm@16"
      "openjdk@17"
      {
        name = "ollama";
        restart_service = "changed";
      }
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
      "orbstack"
      "signal"
      "spotify"
      "wezterm"
    ];

    masApps = {
      "Tailscale"   = 1475387142;
    };
  };

  services.nix-daemon.enable = true;
  security.pam.enableSudoTouchIdAuth = true;
}
