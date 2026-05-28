{
  config,
  lib,
  pkgs,
  user,
  ...
}:

with lib;

{
  options.gaming = {
    enable = mkEnableOption "gaming support (Steam, gamemode)";
    sunshine.enable = mkEnableOption "Sunshine game streaming server";
  };

  config = mkMerge [
    (mkIf config.gaming.enable {
      programs = {
        steam = {
          enable = true;
          remotePlay.openFirewall = true;
          localNetworkGameTransfers.openFirewall = false;
        };
        gamemode.enable = true;
        gamescope = {
          enable = true;
          capSysNice = true;
        };
      };

      # uhid: DualSense (DS5) gamepad emulation
      boot.kernelModules = [ "uhid" ];

      # Aggressive OOM handling for gaming
      systemd.oomd.enable = true;
      services.earlyoom.enable = mkForce false;
    })

    (mkIf (!config.gaming.enable) {
      # Conservative OOM handling when not gaming
      services.earlyoom.enable = true;
    })

    (mkIf (config.gaming.enable && config.gaming.sunshine.enable) {
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
    })
  ];
}
