{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.secureboot.enable = lib.mkEnableOption "Secure Boot via lanzaboote";

  config = lib.mkIf config.secureboot.enable {
    environment.systemPackages = [ pkgs.sbctl ];

    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
