{
  colors,
  lib,
  pkgs,
  ...
}:
let
  qml = import ../../lib/qml.nix { inherit lib; };
  theme = pkgs.writeText "Theme.qml" (
    qml.singleton (
      colors
      // {
        font = "Monaspace Neon";
        radius = 5;
        pad = 12;
        barHeight = 45;
        iconSize = 14;
        cava = "${./quickshell/cava.cfg}";
      }
    )
  );
  shell = pkgs.runCommand "quickshell" { } ''
    mkdir -p $out
    cp -r ${./quickshell}/. $out/
    cp ${theme} $out/Theme.qml
  '';
in
{
  home.packages = [ pkgs.cava ];

  qt.enable = true;

  programs.quickshell = {
    enable = true;
    systemd.enable = true;
  };

  xdg.configFile.quickshell = {
    source = shell;
    force = true;
  };
}
