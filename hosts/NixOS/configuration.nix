{
  config,
  pkgs,
  user,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/secure-boot.nix
    ../../nixos/tpm-luks.nix
    ../../nixos/gui.nix
    ../../nixos/gaming.nix
    ../../nixos/virtualization.nix
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
      "nvidia_drm.fbdev=1"
      "pcie_aspm=off"
    ];

    kernel.sysctl."kernel.sysrq" = 1;
  };

  networking.hostName = "Gordon";

  ### GAMING ###
  gaming.enable = true;
  gaming.sunshine.enable = true;

  ### VIRTUALIZATION ###
  virtualization.vm.enable = false;

  services.flatpak.enable = true;
  services.fstrim.enable = true;
  services.smartd.enable = true;
  environment.systemPackages = with pkgs; [ smartmontools ];

  hardware.cpu.amd.updateMicrocode = true;

  ### NVIDIA / GRAPHICS ###
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaPersistenced = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    moduleParams.nvidia.NVreg_EnableResizableBar = 1;
  };

  systemd.services.nvidia-power-limit = {
    description = "NVIDIA power limit to VBIOS maximum";
    wantedBy = [ "multi-user.target" ];
    after = [ "nvidia-persistenced.service" ];
    wants = [ "nvidia-persistenced.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -pl 350";
    };
  };

  programs.nix-ld.enable = true;

  system.stateVersion = "26.05";
}
