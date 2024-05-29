{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mas
  ];

  # Enable the Nix daemon service
  services.nix-daemon.enable = true;
}
