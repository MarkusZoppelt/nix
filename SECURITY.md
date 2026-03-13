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

Enroll the TPM into both LUKS volumes (PCR 0 = firmware, PCR 7 = Secure Boot state, PCR 12 = kernel cmdline):

    sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7+12 /dev/nvme0n1p2
    sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7+12 /dev/nvme0n1p3

Re-enroll after BIOS firmware updates or Secure Boot key changes (PCR 0 and PCR 7 will change):

    sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/nvme0n1p2
    sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/nvme0n1p3
    # then re-run the enroll commands above

## BIOS updates

PCR 0 seals to the UEFI firmware image. Before flashing: remove the TPM2 key slot from all four LUKS
containers so the next boot falls back to passphrase (data is untouched — know your passphrase before
proceeding):

    sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/nvme0n1p2
    sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/nvme0n1p3
    sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/sda1
    sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/sdb1

Flash the BIOS, then re-enroll the TPM (see above). Secure Boot keys survive firmware updates and do not need to be re-enrolled.

## SATA SSD setup (/dev/sda and /dev/sdb) — one-time provisioning

Each drive needs a single GPT partition with the correct partition label, formatted as LUKS2.
Run these commands once (you will be prompted to set a passphrase — keep it as a fallback):

    # Partition and format data1 (/dev/sda)
    sudo sgdisk -Z /dev/sda
    sudo sgdisk -n 1:0:0 -t 1:8309 -c 1:crypt-data1 /dev/sda
    sudo cryptsetup luksFormat --type luks2 --pbkdf argon2id /dev/sda1
    sudo cryptsetup open /dev/sda1 crypt-data1
    sudo mkfs.btrfs -L data1 /dev/mapper/crypt-data1
    sudo cryptsetup close crypt-data1

    # Partition and format data2 (/dev/sdb)
    sudo sgdisk -Z /dev/sdb
    sudo sgdisk -n 1:0:0 -t 1:8309 -c 1:crypt-data2 /dev/sdb
    sudo cryptsetup luksFormat --type luks2 --pbkdf argon2id /dev/sdb1
    sudo cryptsetup open /dev/sdb1 crypt-data2
    sudo mkfs.btrfs -L data2 /dev/mapper/crypt-data2
    sudo cryptsetup close crypt-data2

## TPM2 enroll for SATA SSDs (run after provisioning, with Secure Boot active)

    sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7+12 /dev/sda1
    sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7+12 /dev/sdb1

Re-enroll after BIOS firmware updates or Secure Boot key changes:

    sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/sda1
    sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/sdb1
    # then re-run the enroll commands above

## LUKS header backups (run after initial setup, keep off-machine)

The LUKS header contains the key slots. If it gets corrupted the encrypted data is unrecoverable.
Back up all four headers and store them somewhere safe (encrypted USB, password manager attachment, etc.):

    sudo cryptsetup luksHeaderBackup /dev/nvme0n1p2 --header-backup-file luks-header-nixos-root.bin
    sudo cryptsetup luksHeaderBackup /dev/nvme0n1p3 --header-backup-file luks-header-nixos-swap.bin
    sudo cryptsetup luksHeaderBackup /dev/sda1      --header-backup-file luks-header-crypt-data1.bin
    sudo cryptsetup luksHeaderBackup /dev/sdb1      --header-backup-file luks-header-crypt-data2.bin

To restore a header (only if the on-disk header is damaged — do not restore to wrong device):

    sudo cryptsetup luksHeaderRestore /dev/sda1 --header-backup-file luks-header-crypt-data1.bin

Re-run header backups after any key slot changes (TPM re-enrollment, passphrase change, etc.).
