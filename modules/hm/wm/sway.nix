{ config, lib, utils, pkgs, ... }:
let
  inherit (lib) mkIf;

  cfg = config.opt.wm;
  vars = {
    conf.colors = cfg.colors;
    conf.theme.common = cfg.theme.common;
    conf.terminal = cfg.terminal;
    conf.folders.bin = "/home/deck/bin";
    conf.wallpaper = cfg.wallpaper;
  };

in
{
  config = mkIf (cfg.enable && cfg.sway)
    {
      home.packages = [
        pkgs.libqalculate
      ];
      home.file."bin/swayexit" = {
        source = ./config/sway/swayexit;
        executable = true;
      };
      home.file."bin/=" = {
        source = ./config/sway/calc;
        executable = true;
      };
      home.file."bin/rotate.sh" = {
        source = ./config/sway/wrotate.sh;
        executable = true;
      };
      home.file."bin/w-stop" = {
        text = "waydroid session stop";
        executable = true;
      };
      home.file."bin/w-size" = {
        text = ''#/usr/bin/bash
          set -e
          if [ "$1" == "1" ];then
            W=770
            H=1280
          elif [ "$1" == "2" ];then
            W=1920
            H=1080
          else
            W=1280
            H=770
          fi
          waydroid prop set persist.waydroid.height "$H"
          waydroid prop set persist.waydroid.width "$W"
          waydroid session stop
          '';
        executable = true;
      };
      xdg.configFile."sway/config" = {
        source = utils.templateFile "config" ./config/sway/config vars;
        executable = true;
      };
      xdg.configFile."waybar/style.css" = {
        source = utils.templateFile "style.css" ./config/sway/style.css vars;
      };
      xdg.configFile."sway/config.d/80-custom.conf".text = ''
        for_window [class="steam"] floating enable
        # for_window [title="Picture-in-Picture"] floating enable, sticky enable
      '';
      xdg.configFile."bash/profile.d/90_sway.sh".text = ''
        case ":$PATH:" in
            *":/var/lib/flatpak/exports/bin:"*) ;;
            *) export PATH=/var/lib/flatpak/exports/bin:$PATH ;;
        esac
      '';
    };
}
