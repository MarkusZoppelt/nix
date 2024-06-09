{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services = {
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;

    jellyfin.enable = true;

    # paperless = {
    #   enable = true;
    #   address = "0.0.0.0";
    #   port = 58080;
    #   settings = {
    #     PAPERLESS_OCR_LANGUAGE = "deu+eng";
    #   };
    # };

    tailscale.useRoutingFeatures = "client";

    # cockpit = {
    #   enable = true;
    #   port = 9090;
    #   settings = {
    #     WebService = {
    #       AllowUnencrypted = true;
    #     };
    #   };
    # };
  };

  systemd.services = {
    NetworkManager-wait-online.enable = false;
    # soft-serve = {
    #   description = "Soft Serve";
    #   wantedBy = ["multi-user.target"];
    #   restartIfChanged = true;
    #   environment = {
    #     SOFT_SERVE_PORT = "23231";
    #     SOFT_SERVE_INITIAL_ADMIN_KEYS = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBAZsJV39WDsTV1lN3jHwqFiDIgvoAEe5G3Ui9flUmBvNe4iqOlsONDN/d/ZSS/dDtEkop2NU/3Tx52tw3RPYAn4=";
    #   };
    #   serviceConfig = {
    #     Type = "simple";
    #     Restart = "always";
    #     RestartSec = "1";
    #     WorkingDirectory = "/soft";
    #     ExecStart = ''
    #       ${pkgs.soft-serve}/bin/soft serve
    #     '';
    #   };
    # };
    # paperless-scheduler.after = ["var-lib-paperless.mount"];
    # paperless-consumer.after = ["var-lib-paperless.mount"];
    # paperless-web.after = ["var-lib-paperless.mount"];
  };

  # virtualisation.oci-containers = {
  #   backend = "docker";
  #   containers.homeassistant = {
  #     volumes = [ "home-assistant:/config" ];
  #     environment.TZ = "Europe/Berlin";
  #     image = "ghcr.io/home-assistant/home-assistant:stable";
  #     extraOptions = [
  #       "--net=host"
  #     ];
  #   };
  # };

  networking.hostName = "Homelab";
  environment.systemPackages = with pkgs; [
    # cockpit
    # soft-serve
  ];
  system.stateVersion = "24.11";
}
