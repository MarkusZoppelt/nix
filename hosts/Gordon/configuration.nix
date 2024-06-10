{ config, pkgs, inputs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  ### BOOTLOADER & INITRD ###
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];

  networking.hostName = "Gordon";

  ### USER CONFIGURATION ###
  users.users.mz = {
    packages = with pkgs; [
      tor-browser
    ];
    extraGroups = [
      "qemu-libvirtd" "libvirtd"
      "wheel" "networkmanager"
    ];
  };

  ### VIRTUALIZATION ###
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  ### DOCKER ###
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  ### NVIDIA / GRAPHICS ###
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
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

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  system.stateVersion = "23.11";
}
