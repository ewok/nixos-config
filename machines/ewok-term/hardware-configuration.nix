{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "vmd" ];
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest;
  boot.extraModulePackages = [ ];
  # boot.blacklistedKernelModules = [ "snd_hda_intel" "snd_soc_skl" ];
  # boot.extraModprobeConfig = ''
  #   options snd-hda-intel dmic_detect=0
  # '';

  fileSystems."/" =
    { device = "/dev/mapper/nixos";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."nixos".device = "/dev/disk/by-label/main";

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-label/swap"; }
    ];
}
