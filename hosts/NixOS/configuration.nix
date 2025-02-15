{ config, pkgs, inputs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  ### BOOTLOADER & INITRD ###
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];

  networking.hostName = "NixOS";
  systemd.services.NetworkManager-wait-online.enable = false;

  ### USER CONFIGURATION ###
  users.users.mz = {
    packages = [];
    extraGroups = [ "docker" "wheel" "networkmanager"];
  };

  virtualisation.docker.enable = true;

  ### NVIDIA / GRAPHICS ###
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  system.stateVersion = "24.11";
}
