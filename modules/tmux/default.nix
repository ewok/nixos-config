{ config, lib, pkgs, utils, ... }:
with lib;
let
  cfg = config.opt.tmux;

  tm = pkgs.writeScriptBin "tm" ''
    #!${pkgs.bash}/bin/bash
    if [[ $1 == "" ]];then
      SESSION="main"
    else
      SESSION="$1"
    fi
    tmux attach -t $SESSION || tmux new -s $SESSION
  '';

  tssh = pkgs.writeScriptBin "tssh" ''
    #!${pkgs.bash}/bin/bash
    argv=( "$@" )
    C=1
    tmux new-window "ssh ''${argv[0]}"
    for i in "''${argv[@]:1}";do
    tmux split-window -h "ssh $i"
    C=$((C + 1))
    done
    if [ "$#" -gt 4 ];then
    tmux select-layout tiled
    else
    tmux select-layout even-vertical
    fi
  '';

  vars = {
    conf.colors = cfg.colors;
    conf.theme = cfg.theme;
    conf.terminal = cfg.terminal;
  };

in
{
  options.opt = {
    tmux = {
      enable = mkEnableOption "tmux";
      install = mkOption {
        type = types.bool;
        default = true;
      };
      terminal = mkOption {
        type = types.str;
        default = "tmux-256color";
      };

      theme = mkOption {
        type = types.attrsOf types.str;
        default = {
          name = "onedark";
          separator_left = "";
          separator_right = "";
          alt_separator_left = "";
          alt_separator_right = "";
        };
      };

      colors = mkOption {
        type = types.attrsOf types.str;
        default = {
          base00 = "282c34";
          base01 = "353b45";
          base02 = "3e4451";
          base03 = "545862";
          base04 = "565c64";
          base05 = "abb2bf";
          base06 = "b6bdca";
          base07 = "c8ccd4";
          base08 = "e06c75";
          base09 = "d19a66";
          base0A = "e5c07b";
          base0B = "98c379";
          base0C = "56b6c2";
          base0D = "61afef";
          base0E = "c678dd";
          base0F = "be5047";
        };
      };

    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; let
      optionalPkgs = optionals cfg.install [tmux];
    in
    [
      gnugrep
      procps
      tm
      tssh
    ] ++ optionalPkgs;
    xdg.configFile."tmux/tmux.conf".source = utils.templateFile "tmux.conf" ./config/tmux.conf vars;
  };
}
