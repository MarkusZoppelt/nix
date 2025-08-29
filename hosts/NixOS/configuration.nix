{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/gui.nix
  ];

  boot = {
    # Limine bootloader with Secure Boot support
    loader = {
      systemd-boot.enable = false;
      grub.enable = false;
      limine = {
        enable = true;
        secureBoot.enable = true;
      };
      timeout = 0;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    # Secure Boot configuration
    bootspec.enable = true;
    
    plymouth = {
      enable = true;
      theme = "hexagon_alt";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "hexagon_alt" ];
        })
      ];
    };

    # Enable Plymouth in initrd for LUKS decryption
    initrd.systemd.enable = true;

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
  };

  networking.hostName = "Gordon";

  ### USER CONFIGURATION ###
  users.users.mz = {
    packages = with pkgs; [
      (btop.override { cudaSupport = true; })
      remmina
    ];
  };

  ### NVIDIA / GRAPHICS ###
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  # Security and Secure Boot related services
  security = {
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
  };

  # Additional packages for Secure Boot management
  environment.systemPackages = with pkgs; [
    sbctl  # Secure Boot key manager
    tpm2-tools
  ];

  system.stateVersion = "25.04";
}
