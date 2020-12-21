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

  networking.hostName = "${deviceName}";
  networking.networkmanager.enable = true;

  # networking.useDHCP = false;
  # networking.interfaces.enp0s31f6.useDHCP = true;
  # networking.interfaces.wlp0s20f3.useDHCP = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "20.09"; # Did you read the comment?
}
