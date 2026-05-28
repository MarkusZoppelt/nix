{ pkgs, user, ... }:
{
  ### GENERAL CONFIGURATION ###
  nix = {
    settings.experimental-features = "nix-command flakes";
    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    optimise.automatic = true;
  };

  nixpkgs.config.allowUnfree = true;

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      # Trust Tailscale interface completely
      trustedInterfaces = [ "tailscale0" ];
      # Deny all other incoming connections by default
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
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
    description = "${user}";
    extraGroups = [
      "wheel"
      "disk"
      "networkmanager"
    ];
  };
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

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
