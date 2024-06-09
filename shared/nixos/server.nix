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
    ];
  };
  users.defaultUserShell = pkgs.zsh;

  ### PROGRAMS ###
  programs.zsh = {
    enable = true;
    shellInit = ''export NIX_LD=$(nix eval --impure --raw --expr '
    let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD ')'';
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  ### ENVIRONMENT ###
  environment.systemPackages = with pkgs; [
    btop
    clang
  ];

  ### SERVICES ###
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
  services.tailscale.enable = true;
  services.pcscd.enable = true;
}
