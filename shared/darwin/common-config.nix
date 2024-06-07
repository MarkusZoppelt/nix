{ pkgs, ... }:
{
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
      "nikitabobko/tap"
    ];

    brews = [
      "ollama"
      "yubikey-agent"
    ];

    casks = [
      "aerospace"
      "alacritty"
      "chatgpt"
      "orbstack"
      "raycast"
      "wezterm"
    ];

    masApps = {
      "Tailscale"   = 1475387142;
      "Xcode"       = 497799835;
    };
  };

  # Enable the Nix daemon service
  services.nix-daemon.enable = true;
  security.pam.enableSudoTouchIdAuth = true;

}
