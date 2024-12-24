{ config, lib, utils, ... }:
let
  inherit (lib) mkIf;

  cfg = config.opt.wm;
  vars = {
    conf.colors = cfg.colors;
    conf.theme = cfg.theme;
    conf.terminal = cfg.terminal;
    conf.folders.bin = "/home/deck/bin";
  };

in
{
  config = mkIf (cfg.enable && cfg.sway)
    {
      home.file."bin/swayexit" = {
        source = ./config/sway/swayexit;
        executable = true;
      };
      xdg.configFile."sway/config" = {
        source = utils.templateFile "config" ./config/sway/config vars;
        executable = true;
      };
      xdg.configFile."sway/config.d/10-browser.conf".text = ''
        for_window [class="Vivaldi-flatpak"] mark Browser
      '';
      xdg.configFile."sway/config.d/10-io.conf".text = ''
        input type:touchpad {
            tap enabled
            natural_scroll enabled
        }

        input * {
            xkb_layout "us,ru"
            xkb_options "grp:win_space_toggle"
            repeat_delay 200
            repeat_rate 30
        }
      '';
      xdg.configFile."waybar/style.css" = {
        source = utils.templateFile "style.css" ./config/sway/style.css vars;
      };
    };
}
