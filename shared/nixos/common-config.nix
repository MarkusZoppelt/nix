{ pkgs, ... }:
{
  ### GENERAL CONFIGURATION ###
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

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
      spotify
      wl-clipboard
    ];
  };
  users.defaultUserShell = pkgs.zsh;

  ### DESKTOP ENVIRONMENT ###
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  ### FONTS ###
  fonts = {
    packages = with pkgs; [
      monaspace
    ];
  };

  ### SOUND ###
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  ### PROGRAMS ###
  programs = {
    direnv.enable = true;
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
    };
    tmux = import ../tmux.nix;
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
  environment.systemPackages = import ../packages.nix { inherit pkgs; };

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
}
