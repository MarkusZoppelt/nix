{ pkgs, ... }:
{
  ### GENERAL CONFIGURATION ###
  nixpkgs.config.allowUnfree = true;
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


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
  services.xserver.enable = true;
  programs.hyprland.enable = true;
  programs.waybar.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


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


  ### PROGRAMS ###
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
  };
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
    hyprlock
    pavucontrol
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
}
