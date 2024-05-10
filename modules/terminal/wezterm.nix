{ config, lib, utils, pkgs, ... }:
with lib;
let
  cfg = config.opt.terminal;
  vars = {
    steamdeck = cfg.steamdeck;
    theme = cfg.theme.name;
    light_theme = cfg.theme.light_name;
  };
  toggle_theme = pkgs.writeShellScriptBin "toggle-theme" ''
    if [ -z "$TMUX" ]; then
      printf "\033]1337;SetUserVar=%s=%s\007" THEME $(echo -n $1 | base64)
    else
      printf "\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\" THEME $(echo -n $1 | base64)
    fi

    if [ "$1" == "dark" ];then
      touch /tmp/theme_dark
      rm -f /tmp/theme_light
    else
      touch /tmp/theme_light
      rm -f /tmp/theme_dark
      fi
  '';
in
{
  config = mkIf (cfg.enable && cfg.terminal == "wezterm") {
    home.file.".wezterm.lua".source = utils.templateFile ".wezterm.lua" ./config/wezterm.lua vars;
    home.packages = [ toggle_theme ];
  };
}
