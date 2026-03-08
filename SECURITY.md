# Security Setup

## Secure Boot (run once after first boot)

Generate keys and sign the ESP:

    sudo sbctl create-keys
    sudo nixos-rebuild switch --flake .#NixOS
    sudo sbctl verify  # all files except kernel bzImage should be signed

Enter BIOS → set Secure Boot to **Setup Mode** (clears factory keys), then:

    sudo sbctl enroll-keys --microsoft

Enable Secure Boot in BIOS and reboot.

## TPM2 disk unlock (run once after Secure Boot is enabled)

Enroll the TPM into both LUKS volumes (PCR 7 = Secure Boot state):

    sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme0n1p2
    sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme0n1p3

Re-enroll after BIOS firmware updates or Secure Boot key changes (PCR 7 will change):

    sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/nvme0n1p2
    sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/nvme0n1p3
    # then re-run the enroll commands above

## BIOS updates

Before flashing: wipe TPM slots so the next boot falls back to passphrase (know your passphrase before proceeding):

    sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/nvme0n1p2
    sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/nvme0n1p3

Flash the BIOS, then re-enroll the TPM (see above). Secure Boot keys survive firmware updates and do not need to be re-enrolled.
