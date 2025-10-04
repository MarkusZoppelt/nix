{ config, lib, pkgs, user, ... }:

with lib;

{
  options.virtualization.vm = {
    enable = mkEnableOption "virtual machine support (QEMU/libvirt)";
  };

  config = mkIf config.virtualization.vm.enable {
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = false;
          swtpm.enable = true;
          ovmf = {
            enable = true;
            packages = [ pkgs.OVMFFull.fd ];
          };
        };
      };
      spiceUSBRedirection.enable = true;
    };

    users.users.${user} = {
      packages = with pkgs; [
        virt-manager
      ];
      extraGroups = [ "libvirtd" "kvm" ];
    };
  };
}
