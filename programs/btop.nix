{ pkgs, ... }:

{
  programs.btop = {
    enable = true;
    package = if pkgs.stdenv.isLinux then pkgs.btop.override { cudaSupport = true; } else pkgs.btop;
    settings = {
      color_theme = "tokyo-night";
    };
  };
}
