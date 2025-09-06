{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/gui.nix
  ];

  networking.hostName = "NixOS";

  ### USER CONFIGURATION ###
  users.users.mz = {
    packages = with pkgs; [
      mesa-demos
      spice
      spice-vdagent
    ];
  };

  ### VM SUPPORT ###
  services.xserver.videoDrivers = [ "modesetting" ];
  services.spice-vdagentd.enable = true;

  system.stateVersion = "25.05";
}
