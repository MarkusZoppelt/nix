{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.unstable.ghostty-bin else pkgs.unstable.ghostty;
    settings = {
      theme = "TokyoNight";
      font-family = "Monaspace Neon";
    };
  };
}
