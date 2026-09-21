{
  pkgs,
  lib,
  user,
  ...
}:
let
  cache = import ./alyx-cache.nix;
  configFile = pkgs.writeText "harmonia.toml" ''
    bind = "0.0.0.0:${toString cache.port}"
    workers = 4
    max_connection_rate = 256
    priority = 10
    enable_compression = false
    sign_key_paths = [ "${cache.secretKeyPath}" ]
    nix_db_path = "/nix/var/nix/db/db.sqlite"
  '';
in
{
  launchd.daemons.harmonia = {
    command = lib.getExe pkgs.harmonia;
    environment = {
      CONFIG_FILE = "${configFile}";
      HOME = "/var/lib/harmonia";
      RUST_LOG = "info";
    };
    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/var/lib/harmonia/harmonia.log";
      StandardErrorPath = "/var/lib/harmonia/harmonia.log";
    };
  };

  system.activationScripts.extraActivation.text = ''
    install -d -m 0755 /var/lib/harmonia
    if [ ! -f ${cache.secretKeyPath} ]; then
      if [ -f /Users/${user}/.config/harmonia/secret ]; then
        cp /Users/${user}/.config/harmonia/secret ${cache.secretKeyPath}
      else
        /nix/var/nix/profiles/default/bin/nix-store --generate-binary-cache-key alyx-1 \
          ${cache.secretKeyPath} /var/lib/harmonia/pub
        echo "harmonia: generated signing key, update lib/alyx-cache.nix:" >&2
        cat /var/lib/harmonia/pub >&2
      fi
      chmod 600 ${cache.secretKeyPath}
    fi
  '';
}
