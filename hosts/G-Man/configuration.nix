{ pkgs, ... }:
{
  nix.settings.experimental-features = "nix-command flakes";
  programs.direnv.enable = true;
  environment.systemPackages = with pkgs; [
    azure-cli
    llvm_16
  ];

  programs.zsh.enable = true;

  services.nix-daemon.enable = true;
  security.pam.enableSudoTouchIdAuth = true;
  networking.hostName = "G-Man";

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    brews = [
      "ollama"
      # "llvm@16"
      "yubikey-agent"
    ];

    casks = [
      "1password"
      "1password-cli"
      "slack"
      "visual-studio-code"
    ];

    masApps = {
      "Xcode"       = 497799835;
      "Microsoft Remote Desktop" = 1295203466;
    };
  };
}
