{ pkgs, ... }:
{
  systemd.services.NetworkManager-wait-online.enable = false;

  hardware.graphics.enable = true;

  fonts.packages = with pkgs; [ monaspace ];

  environment = {
    systemPackages = with pkgs; [
      _1password-gui
      (chromium.override { enableWideVine = true; })
      gnome-session
      hyprshot
      ncspot
      pcsclite
      pkg-config
      wiremix
      wl-clipboard
    ];
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      # GDM 50's greeter kiosk session needs to find gnome-session files.
      XDG_DATA_DIRS = [ "${pkgs.gdm}/share" ];
    };
    variables = {
      TERMINAL = "ghostty";
    };
  };

  programs = {
    ausweisapp = {
      enable = true;
      openFirewall = true;
    };
    hyprland.enable = true;
    waybar.enable = true;
    hyprlock.enable = true;
    dconf.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      excludePackages = with pkgs; [ xterm ];
    };

    displayManager.gdm = {
      enable = true;
      autoSuspend = false;
    };
    gnome.gnome-settings-daemon.enable = true;
    gnome.gnome-keyring.enable = true;
    hypridle.enable = true;

    dbus.packages = [
      pkgs.gnome-keyring
      pkgs.gcr
    ];

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    playerctld.enable = true;

    power-profiles-daemon.enable = true;

    # for mounting stuff
    gvfs.enable = true;
    udisks2.enable = true;
  };

  xdg.portal.enable = true;

  security = {
    pam.services = {
      hyprlock = { };
      login.enableGnomeKeyring = true;
      gdm-password.enableGnomeKeyring = true;
    };
    rtkit.enable = true;
    polkit.enable = true;
  };
}
