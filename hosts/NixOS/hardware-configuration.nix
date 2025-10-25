# Generic hardware configuration using filesystem labels
# This configuration can be shared and used on any machine with consistently labeled partitions
#
# Required labels (set these during installation or with the provided script):
#   Boot partition:      nixos-boot       (vfat/EFI)
#   Root filesystem:     nixos-root       (ext4, inside LUKS)
#   Swap:                nixos-swap       (swap, inside LUKS)
#   Root LUKS container: nixos-crypt-root (GPT partition label)
#   Swap LUKS container: nixos-crypt-swap (GPT partition label)
#
# Run hosts/NixOS/label-partitions.sh to label your partitions automatically.
{
  config,
  lib,
  modulesPath,
  ...
}:

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
  ];
  boot.initrd.kernelModules = [ ];

  # Auto-detect CPU vendor and load appropriate KVM module
  boot.kernelModules =
    lib.optional config.hardware.cpu.amd.updateMicrocode "kvm-amd"
    ++ lib.optional config.hardware.cpu.intel.updateMicrocode "kvm-intel";

  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos-root";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."nixos-crypt-root".device = "/dev/disk/by-partlabel/nixos-crypt-root";
  boot.initrd.luks.devices."nixos-crypt-swap".device = "/dev/disk/by-partlabel/nixos-crypt-swap";

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

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp39s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Enable firmware updates for Secure Boot
  hardware.enableRedistributableFirmware = true;
}
