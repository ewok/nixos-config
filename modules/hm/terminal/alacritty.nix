{ config, lib, utils, ... }:
let
  inherit (lib) mkIf;

  cfg = config.opt.terminal;
  vars = {
    conf.colors = cfg.colors;
    conf.theme = cfg.theme;
    conf.terminal = cfg.terminal;
  };
in
{
  config = mkIf (cfg.enable && cfg.terminal == "alacritty") {
    xdg.configFile."alacritty/alacritty.yml".source = utils.templateFile "alacritty.yml" ./config/alacritty.yml vars;
  };
}
