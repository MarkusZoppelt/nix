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

    brews = [
      "ollama"
      "yubikey-agent"
    ];

    casks = [
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

  services.nix-daemon.enable = true;
  security.pam.enableSudoTouchIdAuth = true;
}
