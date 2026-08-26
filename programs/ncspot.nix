{ pkgs, colors, ... }:

{
  programs.ncspot = {
    enable = true;
    package =
      let
        version = "1.4.0";
        src = pkgs.fetchFromGitHub {
          owner = "hrkfdn";
          repo = "ncspot";
          tag = "v${version}";
          hash = "sha256-YJbdXLqFPYKnluHCR5svAGIkzbKH3xYPOnA2uQCK5q4=";
        };
        cargoHash = "sha256-4RRAFThnp06QFb3U4IjRTRc3B9muyajH592ZNWJrJZY=";
      in
      pkgs.ncspot.overrideAttrs (old: {
        inherit version src cargoHash;
        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          inherit src version;
          inherit (old) pname;
          hash = cargoHash;
        };
      });
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
