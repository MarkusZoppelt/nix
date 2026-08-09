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

      # DS5 (uhid) emulation needs non-root access; uinput already covered by steam rules.
      services.udev.extraRules = ''
        KERNEL=="uhid", GROUP="input", MODE="0660", TAG+="uaccess"
      '';

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
          # 0 = advertise HEVC from encoder caps (NVENC on 3080).
          hevc_mode = 0;
        };
        applications =
          let
            hyprctl = getExe' pkgs.hyprland "hyprctl";
            systemctl = "${config.systemd.package}/bin/systemctl";
            # EDID-safe modes on this panel (no 1280x800). Host stays ≥1080p;
            # Moonlight on Deck still requests 1280x800 and Sunshine downscales.
            monNative = "DP-1,3840x2160@144,auto,1.5";
            mon1080 = "DP-1,1920x1080@60,auto,1";
            mon1440 = "DP-1,2560x1440@120,auto,1";
            # Sunshine execs each prep-cmd entry without a shell — one argv each.
            stopIdle = {
              do = "${systemctl} --user stop hypridle.service";
              undo = "${systemctl} --user start hypridle.service";
            };
            dpmsOn = {
              do = "${hyprctl} dispatch dpms on";
              undo = "";
            };
            setMon = mode: {
              do = "${hyprctl} keyword monitor ${mode}";
              undo = "${hyprctl} keyword monitor ${monNative}";
            };
          in
          {
            env = {
              PATH = "$(PATH):$(HOME)/.local/bin";
            };
            apps = [
              {
                name = "Desktop";
                image-path = "desktop.png";
                prep-cmd = [
                  stopIdle
                  dpmsOn
                ];
              }
              {
                name = "Steam Deck (1080p host)";
                image-path = "desktop.png";
                prep-cmd = [
                  stopIdle
                  dpmsOn
                  (setMon mon1080)
                ];
              }
              {
                name = "Steam Deck (1440p host)";
                image-path = "desktop.png";
                prep-cmd = [
                  stopIdle
                  dpmsOn
                  (setMon mon1440)
                ];
              }
              {
                name = "Steam Big Picture";
                image-path = "steam.png";
                detached = [ "setsid steam steam://open/bigpicture" ];
                prep-cmd = [
                  stopIdle
                  dpmsOn
                  (setMon mon1080)
                  {
                    do = "";
                    undo = "setsid steam steam://close/bigpicture";
                  }
                ];
              }
            ];
          };
      };

      systemd.user.services.sunshine = {
        # GDM greeter also reaches graphical-session.target and would steal
        # Sunshine ports (UID >= 1000, so ConditionUser=!@system is useless).
        unitConfig.ConditionUser = user;
        # libseat probes for seatd first (no socket on logind-only systems),
        # silently failing and breaking virtual input device seat attachment.
        environment.LIBSEAT_BACKEND = "logind";
      };
    })
  ];
}
