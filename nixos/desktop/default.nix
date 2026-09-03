{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./quickshell.nix
  ];

  gtk.enable = true;
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  services.hyprpolkitagent.enable = true;
  programs.hex = {
    enable = true;
    autostart = true;
  };

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
