{ pkgs, ... }:
{
  nix.settings.experimental-features = "nix-command flakes";
  programs.direnv.enable = true;
  environment.systemPackages = with pkgs; [
    azure-cli
    passage
    rclone
  ];

  programs.zsh.enable = true;

  services.nix-daemon.enable = true;
  security.pam.enableSudoTouchIdAuth = true;
  networking.hostName = "G-Man";
}
