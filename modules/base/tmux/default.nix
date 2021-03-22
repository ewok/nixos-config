{ config, lib, pkgs, ... }:
with lib;
let
  base = config.modules.base;
  username = config.properties.user.name;

  tm  = pkgs.writeScriptBin "tm" ''
    #!${pkgs.bash}/bin/bash
    if [[ $1 == "" ]];then
      SESSION="main"
    else
      SESSION="$1"
    fi
    tmux attach -t $SESSION || tmux new -s $SESSION
    '';

  tssh  = pkgs.writeScriptBin "tssh" ''
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
in
{
  config = mkIf base.enable {

    home-manager.users."${username}" = {

      home.packages = [
        tm
        tssh
      ];

      programs.tmux = {
        enable = true;
        terminal = "screen-256color";
        baseIndex = 1;
        keyMode = "vi";
        clock24 = true;
        escapeTime = 0;
        historyLimit = 100000;
        plugins = with pkgs.tmuxPlugins;
        [
          copycat # prefix + C-u to find url, n/N to navigate
        ];
        extraConfig = builtins.readFile ./config/tmux.conf;
      };
    };
  };
}
