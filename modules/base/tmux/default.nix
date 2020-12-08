{ config, lib, pkgs, ... }:
with lib;
let
  base = config.modules.base;
  username = config.properties.user.name;
in
{
  config = mkIf base.enable {

    home-manager.users."${username}" = {

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

      home.file."bin/t".text = ''
        #!/usr/bin/env bash
        if [[ $1 == "" ]];then
            SESSION="main"
        else
            SESSION="$1"
        fi
        tmux attach -t $SESSION || tmux new -s $SESSION
      '';
      home.file."bin/t".executable = true;
    };
  };
}
