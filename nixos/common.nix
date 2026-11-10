{
  pkgs,
  user,
  name',
  ...
}:
let
  alyxCache = import ../lib/alyx-cache.nix;
in
{
  ### GENERAL CONFIGURATION ###
  nix = {
    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    optimise.automatic = true;
    settings = {
      extra-substituters = [ alyxCache.substituter ];
      extra-trusted-public-keys = [ alyxCache.publicKey ];
      # Alyx is always-on; still fail fast if Harmonia is down.
      connect-timeout = 5;
    };
  };

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
    };
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  documentation.nixos.enable = false;

  # Clean /tmp on boot
  boot.tmp.cleanOnBoot = true;

  ### USER CONFIGURATION ###
  users.users.${user} = {
    isNormalUser = true;
    description = name';
    extraGroups = [
      "wheel"
      "networkmanager"
      "input"
    ];
    # Keep user services such as the Rex server running without a login.
    linger = true;
  };
  environment.shells = [ pkgs.nushell ];
  users.defaultUserShell = pkgs.nushell;

  ### SERVICES ###
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    fwupd.enable = true;
    tailscale.enable = true;
  };
}
