{ pkgs, ... }:
{
  imports = [
    ./gtk.nix
    ./hyprland.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./mako.nix
    ./waybar.nix
    ./walker.nix
  ];

  services.hyprpolkitagent.enable = true;

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
