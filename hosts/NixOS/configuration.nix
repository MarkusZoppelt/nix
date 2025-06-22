{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/gui.nix
  ];

  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  networking.hostName = "NixOS";

  ### USER CONFIGURATION ###
  users.users.mz = {
    packages = with pkgs; [
      spotify
    ];
  };

  ### NVIDIA / GRAPHICS ###
  hardware.graphics.enable32Bit = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  system.stateVersion = "25.04";
}
