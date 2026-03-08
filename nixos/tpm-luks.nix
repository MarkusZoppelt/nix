{ lib, config, ... }:
{
  options.tpmLuks = {
    enable = lib.mkEnableOption "TPM2 automatic LUKS unlock bound to PCR 7 (Secure Boot state)";
    devices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "LUKS device names (as defined in boot.initrd.luks.devices) to enroll TPM2 unlock for.";
      example = [
        "nixos-crypt-root"
        "nixos-crypt-swap"
      ];
    };
  };

  config = lib.mkIf config.tpmLuks.enable {
    boot.initrd.luks.devices = lib.genAttrs config.tpmLuks.devices (_: {
      crypttabExtraOpts = [
        "tpm2-device=auto"
        "tpm2-pcrs=7"
      ];
    });

    security.tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
  };
}
