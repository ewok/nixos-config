{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
in
  {
    config = mkIf gui.enable {

      services.xserver = {
        layout = "us,ru";
        xkbOptions = "ctrl:swapcaps,grp:win_space_toggle";
        autoRepeatDelay = 200;
        autoRepeatInterval = 30;
      };

      home-manager.users.${username} = {
        services.xcape = {
          enable = true;
          mapExpression = {
            Control_L = "Escape";
          };
        };
      };

    # services.udev.extraRules = ''
    #     ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", RUN+="${pkgs.}/bin/autorandr --batch --change"
    # '';

    };
  }
