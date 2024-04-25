{ config, lib, utils, ... }:
with lib;
let
  cfg = config.opt.terminal;
  vars = {
    steamdeck = cfg.steamdeck;
  };
in
{
  config = mkIf (cfg.enable && cfg.terminal == "wezterm") {
    home.file.".wezterm.lua".source = utils.templateFile ".wezterm.lua" ./config/wezterm.lua vars;
  };
}
