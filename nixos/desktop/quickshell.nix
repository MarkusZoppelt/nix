{
  colors,
  config,
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
        iconSize = 15;
        cava = "${./quickshell/cava.cfg}";
        agentUsage = lib.getExe (import ../../lib/agent-usage.nix { inherit pkgs; });
        systemdRun = lib.getExe' pkgs.systemd "systemd-run";
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

  # The module only sets WantedBy. Hyprland stops and starts the session
  # target on launch, which does not restart a unit that is not PartOf it.
  systemd.user.services.quickshell.Unit.PartOf = [ config.wayland.systemd.target ];

  xdg.configFile.quickshell = {
    source = shell;
    force = true;
  };
}
