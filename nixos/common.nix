{ pkgs, user, ... }:
{
  ### GENERAL CONFIGURATION ###
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = false;

  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  documentation.nixos.enable = false;

  ### USER CONFIGURATION ###
  users.users.${user} = {
    isNormalUser = true;
    description = "${user}";
    extraGroups = [ "docker" "wheel" "disk" "networkmanager"];
  };
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

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
