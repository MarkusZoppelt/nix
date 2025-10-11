{ pkgs, ... }:
{
  boot.loader.efi.canTouchEfiVariables = true;

  systemd.services.NetworkManager-wait-online.enable = false;

  hardware.graphics.enable = true;

  fonts.packages = with pkgs; [ monaspace ];

  environment = {
    systemPackages = with pkgs; [
      chromium
      ghostty
      gnome-disk-utility
      hyprpaper
      hyprpolkitagent
      hyprshot
      mako
      mpv
      nautilus
      papers
      pcsclite
      pkg-config
      spotify
      sushi
      tokyonight-gtk-theme
      walker
      wiremix
      wl-clipboard
      wofi
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    sessionVariables.NIXOS_OZONE_WL = "1";
    variables = {
      TERMINAL = "ghostty";
    };
  };

  programs = {
    hyprland.enable = true;
    waybar.enable = true;
    hyprlock.enable = true;
    dconf = {
      enable = true;
      profiles.user.databases = [{
        settings = {
          "org/gnome/desktop/interface" = {
            gtk-theme = "Tokyonight-Dark";
            color-scheme = "prefer-dark";
          };
        };
      }];
    };
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

    displayManager.gdm.enable = true;
    gnome.gnome-settings-daemon.enable = true;
    gnome.gnome-keyring.enable = true;
    hypridle.enable = true;

    dbus.packages = [ pkgs.gnome-keyring pkgs.gcr ];
    
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
    samba.enable = true;
  };

  security = {
    pam.services = {
      hyprlock = {};
      login.enableGnomeKeyring = true;
    };
    rtkit.enable = true;
    polkit.enable = true;
  };
}
