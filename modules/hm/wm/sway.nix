{ config, lib, utils, ... }:
let
  inherit (lib) mkIf;

  cfg = config.opt.wm;
  vars = {
    conf.colors = cfg.colors;
    conf.theme = cfg.theme;
    conf.terminal = cfg.terminal;
    conf.folders.bin = "/home/deck/bin";
    conf.wallpaper = cfg.wallpaper;
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
      xdg.configFile."waybar/style.css" = {
        source = utils.templateFile "style.css" ./config/sway/style.css vars;
      };
    };
}
