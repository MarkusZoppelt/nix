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
    extraGroups = [ "docker" "wheel" "networkmanager"];
  };
  users.defaultUserShell = pkgs.zsh;

  ### PROGRAMS ###
  programs = {
    direnv.enable = true;
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
    };
    tmux = import ../shared/tmux.nix;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
  environment.systemPackages = import ../shared/packages.nix { inherit pkgs; };

  ### VIRTUALIZATION ###
  virtualisation.docker.enable = true;

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
    syncthing = {
      enable = true;
      user = "mz";
      configDir = "/home/mz/.config/syncthing";
      openDefaultPorts = true;
    };
  };
}
