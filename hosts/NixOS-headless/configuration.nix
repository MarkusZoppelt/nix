{
  imports = [ ./hardware-configuration.nix ];

  ### BOOTLOADER & INITRD ###

  # EFI:
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # Grub:
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];

  networking.hostName = "NixOS";
  systemd.services.NetworkManager-wait-online.enable = false;

  ### USER CONFIGURATION ###
  users.users.mz = {
    packages = [];
    extraGroups = [ "docker" "wheel" "networkmanager"];
  };
  virtualisation.docker.enable = true;

  system.stateVersion = "25.05";
}
