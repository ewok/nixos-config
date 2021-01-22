{ config, pkgs, ... }:
let
  deviceName = config.properties.device.name;
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "${deviceName}"; # Define your hostname.

  networking.networkmanager.enable = true;

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.enableIPv6 = false;

  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "20.09"; # Did you read the comment?
}
