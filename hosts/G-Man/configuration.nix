{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    azure-cli
    rclone
  ];

  networking.hostName = "G-Man";
}
