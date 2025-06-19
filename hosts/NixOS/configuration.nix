{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  ### BOOTLOADER & INITRD ###
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];

  networking.hostName = "NixOS";
  systemd.services.NetworkManager-wait-online.enable = false;

  ### USER CONFIGURATION ###
  users.users.mz = {
    packages = with pkgs; [
      spotify
      wl-clipboard
    ];
    extraGroups = [ "docker" "wheel" "networkmanager"];
  };

  virtualisation.docker.enable = true;

  ### DESKTOP ENVIRONMENT ###
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  ### FONTS ###
  fonts = {
    packages = with pkgs; [
      monaspace
    ];
  };

  ### SOUND ###
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  ### NVIDIA / GRAPHICS ###
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.yubikey-agent.enable = true;
  services.pcscd.enable = true;

  system.stateVersion = "25.04";
}
