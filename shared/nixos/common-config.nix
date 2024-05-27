{ config, pkgs, ... }:
{
  # Example of enabling a NixOS service
  services.openssh.enable = true;

  # Example of configuring the boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Example of setting up firewall
  #networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  #networking.firewall.enable = true;

  users.defaultUserShell = pkgs.zsh;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  services.yubikey-agent.enable = true;
}
