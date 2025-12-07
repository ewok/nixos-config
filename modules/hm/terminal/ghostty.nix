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
  config = mkIf (cfg.enable && cfg.terminal == "ghostty") {
    xdg.configFile."ghostty/config".source = utils.templateFile "ghostty.toml" ./config/ghostty.toml vars;
  };
}
