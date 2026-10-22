{
  lib,
  config,
  ...
}:
let
  # Firmware image, Secure Boot policy (including dbx), kernel cmdline.
  # Not PCR 11: a newly signed UKI with the same cmdline must still unlock.
  pcrs = "0+7+12";
  devices = config.tpmLuks.devices;
in
{
  options.tpmLuks = {
    enable = lib.mkEnableOption "TPM2 automatic LUKS unlock bound to PCRs ${pcrs} (firmware + Secure Boot state + kernel cmdline)";
    devices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        LUKS device names. Each name is a GPT partition label and must match
        `boot.initrd.luks.devices`.
      '';
      example = [
        "nixos-crypt-root"
        "nixos-crypt-swap"
      ];
    };
  };

  config = lib.mkIf config.tpmLuks.enable {
    assertions = [
      {
        assertion =
          lib.sort (a: b: a < b) devices
          == lib.sort (a: b: a < b) (lib.attrNames config.boot.initrd.luks.devices);
        message = ''
          tpmLuks.devices must be exactly the initrd LUKS device names.
          tpmLuks.devices: ${toString devices}
          initrd: ${toString (lib.attrNames config.boot.initrd.luks.devices)}
        '';
      }
    ];

    boot.initrd.luks.devices = lib.genAttrs devices (_: {
      crypttabExtraOpts = [
        "tpm2-device=auto"
        "tpm2-pcrs=${pcrs}"
        "tpm2-measure-pcr=yes"
      ];
    });

    security.tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
  };
}
