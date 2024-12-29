{ config, lib, utils, pkgs, ... }:
let
  inherit (lib) mkIf;

  cfg = config.opt.terminal;
  vars = {
    conf.theme = cfg.theme;
    conf.colors = cfg.colors;
    conf.monospace_font_size = lib.strings.toInt(cfg.theme.monospace_font_size) + 1;
  };
  toggle_theme = pkgs.writeShellScriptBin "toggle-theme" ''
    if [ "$1" == "auto" ];then
      rm -f $HOME/Documents/theme_dark
      rm -f $HOME/Documents/theme_light
    elif [ "$1" == "dark" ];then
      touch $HOME/Documents/theme_dark
      rm -f $HOME/Documents/theme_light
    else
      touch $HOME/Documents/theme_light
      rm -f $HOME/Documents/theme_dark
      fi

    if [ -z "$TMUX" ]; then
      printf "\033]1337;SetUserVar=%s=%s\007" THEME $(echo -n $1 | base64)
    else
      printf "\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\" THEME $(echo -n $1 | base64)
    fi

  '';
in
{
  config = mkIf (cfg.enable && cfg.terminal == "foot") {
    xdg.configFile."foot/foot.ini".source = utils.templateFile "foot.ini" ./config/foot.ini vars;
    home.packages = [ toggle_theme ];
  };
}
