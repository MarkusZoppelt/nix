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
      signal-desktop
      spotify
      wezterm
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
  sound.enable = true;
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
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.firefox.enable = true;


  ### ENVIRONMENT ###
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    btop
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
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
  services.tailscale.enable = true;
  services.yubikey-agent.enable = true;
  services.pcscd.enable = true;


  ### LD FIX ###
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged
    # programs here, NOT in environment.systemPackages.
  ];
}
