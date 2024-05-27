{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    
  ];

  networking.hostName = "Alyx";
}
