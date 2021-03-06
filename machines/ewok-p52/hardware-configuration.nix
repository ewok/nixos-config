# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sr_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [ "kvm-intel" ];
  # boot.kernelPackages =  pkgs.linuxPackages_5_9;
  boot.extraModulePackages = [];

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."nixos".device = "/dev/disk/by-uuid/bd17e8c6-b1aa-4c21-8b14-2aa20b3a37e1";
  boot.initrd.luks.devices."data".device = "/dev/disk/by-label/data_crypted";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

  fileSystems."/mnt/Data" =
    {
      device = "/dev/disk/by-label/data";
      fsType = "ext4";
    };

  fileSystems."/mnt/DataWin" =
    {
      device = "/dev/disk/by-label/Data";
      fsType = "ntfs";
    };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia.prime = {
    sync.enable = true;

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";
  };
  swapDevices = [];

  hardware.opengl.driSupport32Bit = true;
}
