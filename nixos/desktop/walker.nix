{ pkgs, ... }:
{
  services.elephant = {
    enable = true;
  };

  services.walker = {
    enable = true;
    systemd.enable = true;
    settings = {
      theme = "tokyonight";
      close_when_open = true;
      single_click_activation = true;
      as_window = false;
      layer = "overlay";
      anchor_top = true;
      anchor_bottom = true;
      anchor_left = true;
      anchor_right = true;
      placeholders.default = {
        input = "Search";
        list = "No Results";
      };
      providers.default = [
        "desktopapplications"
        "runner"
        "windows"
        "clipboard"
      ];
      keybinds.close = [ "Escape" ];
      keybinds.next = [ "Down" ];
      keybinds.previous = [ "Up" ];
    };
    theme = {
      name = "tokyonight";
      style = builtins.readFile ../walker/themes/tokyonight.css;
    };
  };
}
