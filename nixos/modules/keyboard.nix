{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.nixos.gui;
in
{
  config = mkIf gui.enable {

    services.xserver = {
      layout = "us,ru";
      xkbOptions = "ctrl:swapcaps,grp:ctrl_shift_toggle";
      autoRepeatDelay = 200;
      autoRepeatInterval = 30;
    };

    # services.udev.extraRules = ''
    #     ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", RUN+="${pkgs.}/bin/autorandr --batch --change"
    # '';
  };
}
