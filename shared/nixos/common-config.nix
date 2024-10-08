{ pkgs, ... }:
{
  ### GENERAL CONFIGURATION ###
  nixpkgs.config.allowUnfree = true;
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  ### USER CONFIGURATION ###
  users.users.mz = {
    isNormalUser = true;
    description = "mz";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      alacritty
      protonmail-desktop
      signal-desktop
      spotify
    ];
  };
  users.defaultUserShell = pkgs.zsh;

  ### DESKTOP ENVIRONMENT ###
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = false;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  programs.hyprland.enable = true;
  programs.waybar.enable = true;

  ### SOUND ###
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.zsh = {
    enable = true;
    shellInit = ''export NIX_LD=$(nix eval --impure --raw --expr '
    let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD ')'';
  };

  ### PROGRAMS ###
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    firefox.enable = true;
  };

  ### ENVIRONMENT VARIABLES ###
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    clang
    grim
    hyprlock
    libnotify
    pavucontrol
    slurp
    swaynotificationcenter
    swww
    wl-clipboard
    wofi
  ];

  ### SERVICES ###
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    tailscale.enable = true;
    yubikey-agent.enable = true;
    pcscd.enable = true;
  };

  ### LD FIX ###
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Add any missing dynamic libraries for unpackaged
      # programs here, NOT in environment.systemPackages.
      stdenv.cc.cc
    ];
  };
}
