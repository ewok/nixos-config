{ config, lib, utils, ... }:
with lib;
let
  cfg = config.opt.terminal;
  vars = {
    conf.colors = cfg.colors;
    conf.theme = cfg.theme;
    conf.terminal = cfg.terminal;
  };
in
{
  config = mkIf (cfg.enable && cfg.terminal == "alacritty") {
    # home.packages = with pkgs;
    #   [
    #   ];
    xdg.configFile."alacritty/alacritty.yml".source = utils.templateFile "alacritty.yml" ./config/alacritty.yml vars;
  };
}
