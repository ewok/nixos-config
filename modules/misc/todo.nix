{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
in
  {
    config = {
      home-manager.users.${username} = {
        home.packages = with pkgs; [
          todo-txt-cli
        ];

        xdg.configFile."todo/config".text = ''
          export TODO_DIR="$HOME/Notes/todo"
        '';
      };
    };
  }




