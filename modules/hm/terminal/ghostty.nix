{ config, lib, utils, ... }:
let
  inherit (lib) mkIf;

  cfg = config.opt.terminal;
  vars = {
    conf.colors = cfg.colors;
    conf.theme.common = cfg.theme.common;
    conf.theme.ghostty = cfg.theme.ghostty;
    conf.terminal = cfg.terminal;
    conf.font_size = if cfg.fontSizeOverride == "" then cfg.theme.common.monospace_font_size else cfg.fontSizeOverride;
  };
in
{
  config = mkIf (cfg.enable && cfg.terminal == "ghostty") {
    xdg.configFile."ghostty/config".source = utils.templateFile "ghostty.toml" ./config/ghostty.toml vars;
  };
}
