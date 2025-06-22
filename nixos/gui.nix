{ config, pkgs, ... }:
{
  ### BOOTLOADER & INITRD ###
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  systemd.services.NetworkManager-wait-online.enable = false;

  ### DESKTOP ENVIRONMENT ###
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  services.displayManager.gdm.enable = true;

  programs.hyprland.enable = true;
  programs.waybar.enable = true;
  programs.hyprlock.enable = true;

  programs.dconf.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  ### FONTS ###
  fonts = import ../shared/fonts.nix { inherit pkgs; };

  ### SOUND ###
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  ### GRAPHICS ###
  hardware.graphics = {
    enable = true;
  };

  ### USER CONFIGURATION ###
  users.users.mz = {
    packages = with pkgs; [
      _1password-cli
      _1password-gui
      chromium
      ghostty
      gnome-settings-daemon
      hyprpaper
      nautilus
      networkmanagerapplet
      pavucontrol
      signal-desktop
      wl-clipboard
      wofi
    ];
  };

  ### YUBIKEY SUPPORT ###
  services.yubikey-agent.enable = true;
  services.pcscd.enable = true;
}
