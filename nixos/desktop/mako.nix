{ colors, ... }:
{
  services.mako = {
    enable = true;
    settings = {
      background-color = "${colors.bg}ee";
      text-color = colors.fg;
      border-color = colors.blue;
      border-size = 1;
      border-radius = 8;
      width = 400;
      padding = "20";
      font = "Monaspace Neon 11";
      max-icon-size = 40;
      layer = "overlay";
      default-timeout = 5000;
      "app-name=Spotify" = {
        invisible = 1;
      };
    };
  };
}
