{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.keyboard;

  keyb-layout = pkgs.writeScriptBin "keyb-layout" ''
    #!${pkgs.bash}/bin/bash
    LAYOUT=''${1:-0}
    if [ $LAYOUT -eq 1 ]; then
      setxkbmap -rules "evdev" -model "pc105" -layout "us,ru" -option "grp:win_space_toggle,ctrl:swapcaps,altwin:swap_alt_win"
    else
      setxkbmap -rules "evdev" -model "pc105" -layout "us,ru" -option
    fi
    xset r rate 200 30
  '';
in
{
  options.opt.keyboard.gui = mkOption { type = types.bool; };

  config = {

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
}
