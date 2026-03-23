{
  config,
  lib,
  pkgs,
  user,
  ...
}:

with lib;

{
  options.gaming.enable = mkEnableOption "gaming support (Steam, gamemode, gamescope, Sunshine streaming)";

  config = mkIf config.gaming.enable {
    programs = {
      steam = {
        enable = true;
        gamescopeSession.enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = false;
      };
      gamemode.enable = true;
      gamescope = {
        enable = true;
        capSysNice = true;
      };
    };

    # Steam on Linux+NVIDIA hardcodes --disable-gpu in steamwebhelper, causing
    # some stutter in Big Picture mode. -cef-force-gpu overrides this with
    # --ignore-gpu-blocklist and applies to every steam invocation.
    # https://github.com/ValveSoftware/steam-for-linux/issues/11255
    environment.systemPackages = [
      (pkgs.symlinkJoin {
        name = "steam-cef-force-gpu";
        paths = [ config.programs.steam.package ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/steam --add-flags "-cef-force-gpu"
        '';
      })
    ];

    # uhid: DualSense (DS5) gamepad emulation
    boot.kernelModules = [ "uhid" ];

    users.users.${user}.extraGroups = [
      "input"
      "video"
    ];
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
      package = pkgs.sunshine.override {
        cudaSupport = true;
      };
      settings = {
        output_name = "DP-1";
        high_resolution_scrolling = 1;
      };
    };

    # libseat probes for seatd first (no socket on logind-only systems),
    # silently failing and breaking virtual input device seat attachment.
    systemd.user.services.sunshine.environment.LIBSEAT_BACKEND = "logind";

    # Monitor memory usage and take action before the system runs out of memory.
    systemd.oomd.enable = true;
  };
}
