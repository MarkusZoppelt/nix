{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/gui.nix
  ];

  networking.hostName = "Gordon";

  ### USER CONFIGURATION ###
  users.users.mz = {
    packages = with pkgs; [
      spotify
      (btop.override { cudaSupport = true; })
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

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  system.stateVersion = "25.04";
}
