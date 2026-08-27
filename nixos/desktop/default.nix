{ pkgs, ... }:
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
  programs.hex.enable = true;
  programs.hex.autostart = true;

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
