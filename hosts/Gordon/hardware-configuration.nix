{ config, lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "nvme" "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9f1b2bfb-8c05-4cc9-94a5-af4769ceabb2";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-0d7e2fed-f992-4ae5-acae-2fc123d3c869".device = "/dev/disk/by-uuid/0d7e2fed-f992-4ae5-acae-2fc123d3c869";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0783-1299";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [ ];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
