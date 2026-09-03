{ pkgs, user, ... }:
{
  nix.enable = false;

  system.stateVersion = 5;
  networking.hostName = "Alyx";

  fonts.packages = with pkgs; [ monaspace ];

  # User configuration for Darwin
  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
    shell = pkgs.unstable.nushell;
  };
  system.primaryUser = user;

  environment.shells = [ pkgs.unstable.nushell ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    brews = [
      {
        name = "syncthing";
        restart_service = "changed";
      }
    ];

    casks = [
      "orbstack"
    ];
  };

  # https://nix-darwin.github.io/nix-darwin/manual/
  system.defaults = {
    CustomUserPreferences = {
      # Disable siri
      "com.apple.Siri" = {
        "UAProfileCheckingStatus" = 0;
        "siriEnabled" = 0;
      };
      # Disable personalized ads
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
      };
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on network or USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
    };

    NSGlobalDomain.InitialKeyRepeat = 15;
    NSGlobalDomain.KeyRepeat = 1;

    # Whether to enable “Natural” scrolling direction
    NSGlobalDomain."com.apple.swipescrolldirection" = true;

    # Enable tap to click behaviour
    NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;

    dock.autohide = true;
    dock.autohide-delay = 0.0;
    dock.autohide-time-modifier = 0.0;
    dock.show-recents = false;

    finder.AppleShowAllExtensions = true;
    finder.NewWindowTarget = "Home";
    finder.ShowPathbar = true;
    finder.ShowStatusBar = true;

    screensaver.askForPasswordDelay = 0;
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
