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
      xkbOptions = "ctrl:nocaps, grp:win_space_toggle, grp:rctrl_switch";
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
  };
}
