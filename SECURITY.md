# Security Setup

## Secure Boot (run once after first boot)

Generate keys and sign the ESP:

    sudo sbctl create-keys
    sudo nixos-rebuild switch --flake .#Gordon
    sudo sbctl verify  # all files except kernel bzImage should be signed

Enter BIOS → set Secure Boot to **Setup Mode** (clears factory keys), then:

    sudo sbctl enroll-keys --microsoft

Enable Secure Boot in BIOS and reboot.

## TPM2 disk unlock

PCR 0 is the firmware image. PCR 7 is the Secure Boot policy, including dbx, so a `fwupdmgr` update changes it. PCR 12 is the kernel cmdline. PCR 11 (UKI hash) is not sealed: a newly signed UKI with the same cmdline still unlocks.

The volumes are `tpmLuks.devices` in `hosts/NixOS/configuration.nix`. Open them by partition label, not by kernel name:

    sudo systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=0+7+12 /dev/disk/by-partlabel/NAME

`NAME` is each entry in that list. `systemd-cryptenroll` cannot use the already-open disk; it always asks for the passphrase. The passphrase slot stays. This file does not name disks.

## SATA SSD setup — one-time provisioning

Each data disk needs one GPT partition, labeled `crypt-data1` or `crypt-data2`, formatted LUKS2. Identify the disk by serial. Set `DISK` to its `/dev/disk/by-id/` node with no partition suffix, and confirm that node is the empty disk before wiping it.

    lsblk -d -o NAME,SERIAL,SIZE,MODEL,TRAN

    DISK=/dev/disk/by-id/ata-...
    sudo sgdisk -Z "$DISK"
    sudo sgdisk -n 1:0:0 -t 1:8309 -c 1:crypt-data1 "$DISK"
    sudo udevadm settle
    sudo cryptsetup luksFormat --type luks2 --pbkdf argon2id /dev/disk/by-partlabel/crypt-data1
    sudo cryptsetup open /dev/disk/by-partlabel/crypt-data1 crypt-data1
    sudo mkfs.btrfs -L data1 /dev/mapper/crypt-data1
    sudo cryptsetup close crypt-data1

Repeat with label `crypt-data2` and filesystem label `data2`. Then enroll with the command above.

## LUKS header backups

The header holds the key slots. Back it up after the first enroll and after any reseal, and keep the files off this machine. `NAME` is each `tpmLuks.devices` entry:

    sudo cryptsetup luksHeaderBackup /dev/disk/by-partlabel/NAME --header-backup-file luks-header-NAME.bin

Restore only onto that same volume:

    sudo cryptsetup luksHeaderRestore /dev/disk/by-partlabel/NAME --header-backup-file luks-header-NAME.bin
