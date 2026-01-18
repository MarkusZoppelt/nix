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
  nixpkgs.config.allowUnsupportedSystem = false;

  networking.networkmanager.enable = true;
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
      "docker"
      "wheel"
      "disk"
      "networkmanager"
    ];
  };
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  ### VIRTUALIZATION ###
  virtualisation.docker.enable = true;

  ### SERVICES ###
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    earlyoom.enable = true;
    fwupd.enable = true;
    tailscale.enable = true;
  };
}
