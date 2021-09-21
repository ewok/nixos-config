{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.home.gui;

  todo-full = pkgs.symlinkJoin {
    name = "todo-full";
    paths = let
      todo = pkgs.writeShellScriptBin "t" ''
        export TODOTXT_VERBOSE=0
        if [ "$1" == "do" ];then
          TODO_NO_AGAIN_IF_NOT_TAGGED=1 todo.sh again ''${@:2}
        elif [ "$1" == "doo" ];then
          todo.sh do ''${@:2}
        elif [ "$1" == "lss" ];then
          todo.sh -x ls ''${@:2}
        else
          todo.sh $@
        fi
      '';

    in
      [
        pkgs.todo-txt-cli
        pkgs.todo-txt-again
        todo
      ];
  };
in
{
  config = {
    home.packages = with pkgs; [
      todo-full
    ];

    xdg.configFile."todo/config".text = ''
      export TODO_DIR="$HOME/Notes/todo"
      export TODO_FILE="$TODO_DIR/todo.txt"
      export TODO_ACTIONS_DIR="${todo-full}/todo.actions.d"
      export TODOTXT_FINAL_FILTER="${todo-full}/todo.actions.d/againFilter.sh"
    '';
  };
}
