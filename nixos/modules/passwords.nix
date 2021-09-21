{ config, lib, pkgs, inputs, ... }:
with lib;
let
  gui = config.nixos.gui;
in
{
  config = mkIf gui.enable {

    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;
    security.pam.services.lightdm.enableGnomeKeyring = true;

    environment.systemPackages = with pkgs; [
      gnupg
    ];
    services.pcscd.enable = true;

  };
}
