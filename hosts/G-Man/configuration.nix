{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    azure-cli
  ];

  networking.hostName = "G-Man";

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    brews = [
      "bazelisk"
      "cmake"
      "lcov"
      "llvm@16"
      "openjdk@17"
    ];

    casks = [
      "1password"
      "1password-cli"
      "orbstack"
      "slack"
      "visual-studio-code"
    ];

    masApps = {
      "Xcode"       = 497799835;
      "Microsoft Remote Desktop" = 1295203466;
    };
  };

  environment.variables = {
    PATH = lib.mkForce ''
      /opt/homebrew/opt/llvm@16/bin:$HOME/.npm/bin:${pkgs.lib.makeSearchPath "bin" [ pkgs.nodejs ]}:$PATH
    '';
    LDFLAGS="-L/opt/homebrew/opt/llvm@16/lib";
    CPPFLAGS="-I/opt/homebrew/opt/llvm@16/include";
  };
}
