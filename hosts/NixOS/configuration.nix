{
  config,
  pkgs,
  user,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/gui.nix
    ../../nixos/gaming.nix
    ../../nixos/secure-boot.nix
    ../../nixos/tpm-luks.nix
  ];

  secureboot.enable = true;

  tpmLuks = {
    enable = true;
    devices = [
      "nixos-crypt-root"
      "nixos-crypt-swap"
      "crypt-data1"
      "crypt-data2"
    ];
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    bootspec.enable = true;

    initrd.systemd.enable = true;

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
      # Required for NVIDIA open kernel module + proper KMS/DRM
      "nvidia_drm.fbdev=1"
    ];
  };

  networking.hostName = "Gordon";

  ### USER CONFIGURATION ###
  users.users.${user} = {
    packages = with pkgs; [
      (btop.override { cudaSupport = true; })
    ];
  };

  ### GAMING ###
  gaming.enable = true;

  ### VIRTUALIZATION ###
  virtualization.vm.enable = false;

  services.flatpak.enable = true;
  services.fstrim.enable = true;
  services.smartd.enable = true;
  environment.systemPackages = with pkgs; [ smartmontools ];

  ### NVIDIA / GRAPHICS ###
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  system.stateVersion = "25.05";
}
