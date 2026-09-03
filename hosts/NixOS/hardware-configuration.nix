# Generic hardware configuration using filesystem labels
# This configuration can be shared and used on any machine with consistently labeled partitions
#
# Required labels (set these during installation or with the provided script):
#   Boot partition:      nixos-boot       (vfat/EFI)
#   Root filesystem:     nixos-root       (ext4, inside LUKS)
#   Swap:                nixos-swap       (swap, inside LUKS)
#   Root LUKS container: nixos-crypt-root (GPT partition label)
#   Swap LUKS container: nixos-crypt-swap (GPT partition label)
#   Data1 LUKS container: crypt-data1     (GPT partition label)
#   Data2 LUKS container: crypt-data2     (GPT partition label)
#   Data1 filesystem:     data1           (btrfs, inside LUKS, mounted at /run/media/<user>/data1)
#   Data2 filesystem:     data2           (btrfs, inside LUKS, mounted at /run/media/<user>/data2)
#
# Run hosts/NixOS/label-partitions.sh to label your partitions automatically.
{
  config,
  lib,
  modulesPath,
  user,
  ...
}:

let
  luksDevices = [
    "nixos-crypt-root"
    "nixos-crypt-swap"
    "crypt-data1"
    "crypt-data2"
  ];
  btrfsData = {
    fsType = "btrfs";
    options = [
      "nofail"
      "compress=zstd:3"
      "noatime"
      "space_cache=v2"
      "ssd"
      "discard=async"
    ];
  };
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "ahci"
    "xhci_pci"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "r8169"
  ];

  # Auto-detect CPU vendor and load appropriate KVM module
  boot.kernelModules =
    lib.optional config.hardware.cpu.amd.updateMicrocode "kvm-amd"
    ++ lib.optional config.hardware.cpu.intel.updateMicrocode "kvm-intel";

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos-root";
    fsType = "ext4";
  };

  boot.initrd.luks.devices = lib.genAttrs luksDevices (name: {
    device = "/dev/disk/by-partlabel/${name}";
  });

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/nixos-boot";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-label/nixos-swap"; }
  ];

  fileSystems."/run/media/${user}/Games" = {
    device = "/dev/disk/by-label/Games";
    fsType = "ext4";
    options = [
      "nofail"
      "noatime"
    ];
  };

  fileSystems."/run/media/${user}/data1" = btrfsData // {
    device = "/dev/disk/by-label/data1";
  };

  fileSystems."/run/media/${user}/data2" = btrfsData // {
    device = "/dev/disk/by-label/data2";
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Enable firmware updates for Secure Boot
  hardware.enableRedistributableFirmware = true;
}
