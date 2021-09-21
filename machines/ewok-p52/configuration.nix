{ config, pkgs, inputs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      "${inputs.nixos-hardware}/common/pc/ssd"
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.xserver.libinput.enable = true;

  # i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "20.09"; # Did you read the comment?
}
