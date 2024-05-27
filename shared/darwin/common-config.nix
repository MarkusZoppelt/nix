{ config, pkgs, ... }:
{
  # Enable the Nix daemon service
  services.nix-daemon.enable = true;
}
