{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
  ];

  homebrew = {
    casks = [
      "1password"
      "1password-cli"
      "slack"
      "visual-studio-code"
    ];
  };

  networking.hostName = "G-Man";
}
