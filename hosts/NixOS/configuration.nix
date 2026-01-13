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
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
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
  users.users.${user} = {
    packages = with pkgs; [
      (btop.override { cudaSupport = true; })
      remmina
    ];
  };

  ### GAMING ###
  gaming.enable = true;

  ### VIRTUALIZATION ###
  virtualization.vm.enable = false;

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

  security = {
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
  };

  system.stateVersion = "25.05";
}
