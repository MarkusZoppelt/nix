{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/gui.nix
  ];


  ### USER CONFIGURATION ###
  users.users.mz = {
    packages = with pkgs; [
      spotify
    ];
  };

  ### NVIDIA / GRAPHICS ###
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  system.stateVersion = "25.04";
}
