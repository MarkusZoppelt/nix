{ pkgs, lib, ... }:
{
  # Hyprland desktop environment configuration

  # Hyprland window manager
  xdg.configFile."hypr/hyprland.conf".source = ./hypr/hyprland.conf;
  xdg.configFile."hypr/hyprpaper.conf".source = ./hypr/hyprpaper.conf;
  xdg.configFile."hypr/hypridle.conf".source = ./hypr/hypridle.conf;
  xdg.configFile."hypr/hyprlock.conf".source = ./hypr/hyprlock.conf;
  xdg.configFile."hypr/tokyonight.png".source = ./hypr/tokyonight.png;

  # Waybar status bar
  xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;
  xdg.configFile."waybar/style.css".source = ./waybar/style.css;
  xdg.configFile."waybar/scripts" = {
    source = ./waybar/scripts;
    recursive = true;
  };

  # Mako notifications
  xdg.configFile."mako/config".source = ./mako/config;

  # Walker app launcher
  xdg.configFile."walker/config.toml".source = ./walker/config.toml;
  xdg.configFile."walker/themes" = {
    source = ./walker/themes;
    recursive = true;
  };
}
