{
  pkgs,
  user,
  name',
  ...
}:
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
  };
  environment.shells = [ pkgs.unstable.nushell ];
  users.defaultUserShell = pkgs.unstable.nushell;

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
