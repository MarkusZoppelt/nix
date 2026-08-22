{ config, lib, pkgs, ... }:
{
  imports = [
    ./gtk.nix
    ./hyprland.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./quickshell.nix
  ];

  services.hyprpolkitagent.enable = true;
  services.handy.enable = true;
  systemd.user.services.handy.Service.ExecStart =
    lib.mkForce "${config.services.handy.package}/bin/handy --start-hidden";

  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.hyprland = {
      default = [
        "hyprland"
        "gtk"
      ];
      "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
    };
  };
}
