{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;

  todo = pkgs.writeShellScriptBin "todo" ''
    ROFI_THEME=android_notification todo.sh $@
  '';
in
  {
    config = {
      home-manager.users.${username} = {
        home.packages = with pkgs; [
          todo-txt-cli
          todo
        ];

        xdg.configFile."todo/config".text = ''
          export TODO_DIR="$HOME/Notes/todo"
        '';
      };
    };
  }




