{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    google-cloud-sdk
  ];

  networking.hostName = "Alyx";
}
