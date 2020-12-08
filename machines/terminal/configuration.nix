{ config, pkgs, ... }:
let
  deviceName = config.properties.device.name;
  username = config.properties.user.name;
in
{
  imports =
    [
      ./hardware-configuration.nix
      ../nixflake.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "${deviceName}"; # Define your hostname.

  networking.networkmanager.enable = true;

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;

  i18n.defaultLocale = "en_US.UTF-8";

  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
     git
  ];

  services.openssh.enable = true;
  environment.pathsToLink = [ "/libexec" ];
  system.stateVersion = "20.09"; # Did you read the comment?
}
