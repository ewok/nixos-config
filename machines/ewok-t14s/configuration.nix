{ config, pkgs, inputs, ... }:
let
  deviceName = config.properties.device.name;
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enableCryptodisk = true;

  networking.hostName = "${deviceName}";
  networking.networkmanager.enable = true;
  networking.enableIPv6 = false;
  boot.kernel.sysctl."net.ipv6.conf.all.disable_ipv6" = true;
  boot.kernel.sysctl."net.ipv6.conf.enp0s31f6.disable_ipv6" = true;
  boot.kernel.sysctl."net.ipv6.conf.wlp0s20f3.disable_ipv6" = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  system.stateVersion = "20.09";
}
