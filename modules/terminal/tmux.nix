{ config, lib, pkgs, utils, ... }:
with lib;
let
  cfg = config.opt.terminal;

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

  zoxide-rm = pkgs.writeScriptBin "zoxide-rm" ''
    #!${pkgs.bash}/bin/bash
    EXP=$(echo "$1" | sed "s|~|$HOME|g")
    ${pkgs.zoxide}/bin/zoxide remove $EXP
  '';

  vars = {
    conf.colors = cfg.colors;
    conf.theme = cfg.theme;
    conf.terminal = cfg.tmux.terminal;
  };

in
{
  config = mkIf (cfg.enable && cfg.tmux.enable) {
    home.packages = with pkgs; let
      optionalPkgs = optionals cfg.tmux.install [ tmux ];
    in
    [
      sesh
      zoxide
      zoxide-rm
      fzf
      gnugrep
      procps
      tm
      tssh
      xsel
    ] ++ optionalPkgs;
    xdg.configFile."tmux/tmux.conf".source = utils.templateFile "tmux.conf" ./config/tmux.conf vars;
    xdg.configFile."tmux/tmux_blocks" = {
      source = utils.templateFile "tmux_blocks" ./config/tmux_blocks vars;
      executable = true;
    };
    xdg.configFile."tmux/tmux_battery" = {
      source = ./config/tmux_battery;
      executable = true;
    };
    xdg.configFile."tmux/tmux_cpu" = {
      source = ./config/tmux_cpu;
      executable = true;
    };
    xdg.configFile."tmux/tmux_network" = {
      source = ./config/tmux_network;
      executable = true;
    };
    xdg.configFile."tmux/tmux_ram" = {
      source = ./config/tmux_ram;
      executable = true;
    };
  };
}
