{ config, lib, pkgs, modulesPath, inputs, ... }:
{
  imports =
    [
      "${inputs.nixos-hardware}/common/pc/ssd"
      (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      boot.initrd.kernelModules = [];
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [];

      fileSystems."/" =
        { device = "/dev/disk/by-uuid/7de3383c-3c5b-48eb-aefd-b539c305d4b7";
        fsType = "ext4";
      };

      boot.initrd.luks.devices."luks-0334e899-a609-4000-b514-c2733f1c5d2a".device = "/dev/disk/by-uuid/0334e899-a609-4000-b514-c2733f1c5d2a";

      fileSystems."/boot/efi" =
        { device = "/dev/disk/by-uuid/2CB8-FD75";
        fsType = "vfat";
      };

      swapDevices =
        [
    # { device = "/dev/disk/by-label/swap"; }
  ];
  networking.useDHCP = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
