{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./quickshell.nix
  ];

  # Linger and the GDM greeter reach graphical-session.target before a display
  # exists. Hyprland imports WAYLAND_DISPLAY, then starts this target.
  wayland.systemd.target = "hyprland-session.target";

  gtk.enable = true;
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

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
