{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.keyboard;

  keyb-layout = pkgs.writeScriptBin "keyb-layout" ''
    #!${pkgs.bash}/bin/bash
    LAYOUT=''${1:-0}
    if [ $LAYOUT -eq 1 ]; then
      setxkbmap -rules "evdev" -model "pc105" -layout "us,ru" -option "ctrl:swapcaps"
    else
      setxkbmap -rules "evdev" -model "pc105" -layout "us,ru" -option
    fi
    xset r rate 200 30
  '';
in
{
  options.opt.keyboard.gui = mkOption { type = types.bool; };
  options.opt.keyboard.username = mkOption { type = types.str; };

  config = mkIf cfg.gui {

    services.xserver = {
      layout = "us,ru";
      xkbOptions = "ctrl:swapcaps,grp:ctrl_shift_toggle";
      autoRepeatDelay = 200;
      autoRepeatInterval = 30;
    };

    # services.udev.extraRules = ''
    #     ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", RUN+="${pkgs.}/bin/autorandr --batch --change"
    # '';
    home-manager.users.${cfg.username} = {

      home.packages = [ keyb-layout ];
      services.xcape = {
        enable = true;
        mapExpression = {
          Control_L = "Escape";
        };
      };

      systemd.user.services.xcape-restart = {
        Unit = { Description = "restart xcape"; };
        Service = {
          Type = "simple";
          ExecStart = "/run/current-system/sw/bin/systemctl --user --no-block restart xcape.service";
        };
      };
      systemd.user.timers.xcape-restart = {
        Unit = { Description = "restart xcape"; };
        Timer = {
          Unit = "xcape-restart.service";
          OnCalendar = "daily";
          Persistent = true;
        };
        Install = { WantedBy = [ "timers.target" ]; };
      };

    };
  };
}
