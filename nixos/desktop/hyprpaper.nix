{ config, ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      # The splash text ("Hyprland is not a window manager!" etc.) is
      # rendered by hyprpaper, not Hyprland. `misc.disable_splash_rendering`
      # in hyprland.conf is a no-op for hyprpaper sessions.
      splash = false;
      preload = [ "${config.home.homeDirectory}/.config/hypr/tokyonight.png" ];
      wallpaper = [
        {
          monitor = "DP-1";
          path = "${config.home.homeDirectory}/.config/hypr/tokyonight.png";
          fit_mode = "cover";
        }
      ];
    };
  };

  xdg.configFile."hypr/tokyonight.png".source = ../hypr/tokyonight.png;
}
