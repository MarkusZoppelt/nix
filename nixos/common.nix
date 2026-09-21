{
  pkgs,
  user,
  name',
  ...
}:
let
  alyxCache = import ../lib/alyx-cache.nix;
in
{
  ### GENERAL CONFIGURATION ###
  nix = {
    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    optimise.automatic = true;
    settings = {
      extra-substituters = [ alyxCache.substituter ];
      extra-trusted-public-keys = [ alyxCache.publicKey ];
      # Alyx is always-on; still fail fast if Harmonia is down.
      connect-timeout = 5;
    };
  };

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
    };
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  documentation.nixos.enable = false;

  # Clean /tmp on boot
  boot.tmp.cleanOnBoot = true;

  ### USER CONFIGURATION ###
  users.users.${user} = {
    isNormalUser = true;
    description = name';
    extraGroups = [
      "wheel"
      "networkmanager"
      "input"
    ];
  };
  environment.shells = [ pkgs.nushell ];
  users.defaultUserShell = pkgs.nushell;
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "nix-copy-alyx";
      text = ''
        if [ "$#" -eq 0 ]; then
          set -- /run/current-system
        fi
        # Alyx's login shell is nu; ssh runs `nu -c`, which does not load
        # env.nu, so PATH has no Nix. Absolute path skips that.
        # ssh-ng checks signatures even for trusted users. mz is trusted on
        # Alyx, so --no-check-sigs is honored and unsigned local builds copy.
        exec nix copy --no-check-sigs \
          --to "ssh-ng://alyx?remote-program=/nix/var/nix/profiles/default/bin/nix-daemon" \
          "$@"
      '';
    })
  ];

  ### SERVICES ###
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    fwupd.enable = true;
    tailscale.enable = true;
  };
}
