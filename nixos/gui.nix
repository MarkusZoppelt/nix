{ pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  systemd.services.NetworkManager-wait-online.enable = false;

  hardware.graphics = {
    enable = true;
  };

  fonts = import ../shared/fonts.nix { inherit pkgs; };

  environment = {
    systemPackages = with pkgs; [
      _1password-cli
      _1password-gui
      chromium
      ghostty
      hyprpaper
      hyprpolkitagent
      hyprshot
      mako
      nautilus
      networkmanagerapplet
      obsidian
      papers
      pavucontrol
      pcsclite
      pkg-config
      signal-desktop
      tokyonight-gtk-theme
      wl-clipboard
      wofi
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    sessionVariables.NIXOS_OZONE_WL = "1";
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
    };

    displayManager.gdm.enable = true;
    gnome.gnome-settings-daemon.enable = true;
    hypridle.enable = true;
    
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    playerctld.enable = true;

    # for mounting stuff
    gvfs.enable = true;
    udisks2.enable = true;
    samba.enable = true;

    # YUBIKEY SUPPORT
    yubikey-agent.enable = true;
    pcscd.enable = true;
  };

  security = {
    pam.services.hyprlock = {};
    rtkit.enable = true;
    polkit.enable = true;
  };
}
