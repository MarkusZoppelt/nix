{ ... }:
{
  imports = [
    ./hyprland.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./mako.nix
    ./waybar.nix
    ./walker.nix
  ];

  services.hyprpolkitagent.enable = true;

  xdg.portal.config.common.default = "*";
}
