{ colors, ... }:

{
  programs.ncspot = {
    enable = true;
    settings = {
      use_nerdfont = true;
      theme = {
        background = colors.bg;
        primary = colors.fg;
        secondary = colors.comment;
        title = colors.blue;
        playing = colors.green;
        playing_selected = colors.yellow;
        playing_bg = colors.bg;
        highlight = colors.fg;
        highlight_bg = colors.bg_visual;
        error = colors.red;
        error_bg = colors.bg;
        statusbar = colors.bg;
        statusbar_progress = colors.blue;
        statusbar_bg = colors.blue;
        cmdline = colors.fg;
        cmdline_bg = colors.bg;
        search_match = colors.yellow;
      };
    };
  };
}
