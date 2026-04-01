{ ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "~/.config/hypr/tokyonight.png" ];
      wallpaper = [ ",~/.config/hypr/tokyonight.png" ];
    };
  };

  xdg.configFile."hypr/tokyonight.png".source = ../hypr/tokyonight.png;
}
