{ pkgs, ... }:
{
  system.stateVersion = 5;
  environment.systemPackages = with pkgs; [
    mas
  ];

  # Set up npm so that it installs global packages in the user's home directory
  environment.variables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm";
    PATH = ''
      /opt/homebrew/opt/llvm@16/bin:$HOME/.npm/bin:${pkgs.lib.makeSearchPath "bin" [ pkgs.nodejs ]}:$PATH
    '';
    LDFLAGS="-L/opt/homebrew/opt/llvm@16/lib/c++ -Wl,-rpath,/opt/homebrew/opt/llvm@16/lib/c++";
    CPPFLAGS="-I/opt/homebrew/opt/llvm@16/include";
  };

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
    ];

    masApps = {
      "Tailscale"   = 1475387142;
    };
  };

  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  
  system.defaults.dock.autohide = true;
  system.defaults.dock.autohide-delay = 0.0;
  system.defaults.dock.autohide-time-modifier = 0.0;

  services.nix-daemon.enable = true;
  security.pam.enableSudoTouchIdAuth = true;
}
