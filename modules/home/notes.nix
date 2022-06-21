{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.notes;

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

  todofishCustom = pkgs.writeShellScriptBin "todofi.sh" ''
    export TODOFI_SHORTCUT_NEW="Shift+space"
    export TODOFI_CMD_DO="again"
    export TODO_NO_AGAIN_IF_NOT_TAGGED=1
    ${pkgs.todofish}/bin/todofi.sh $@
  '';

in
  {

    options.opt.notes = {
      enable = mkOption { type = types.bool; };
      username = mkOption {type = types.str;};
    };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [
          todo-full
          todofishCustom
        ];

        xdg.configFile."todo/config".text = ''
          export TODO_DIR="$HOME/Notes/todo"
          export TODO_FILE="$TODO_DIR/todo.txt"
          export TODO_ACTIONS_DIR="${todo-full}/todo.actions.d"
          export TODOTXT_FINAL_FILTER="${todo-full}/todo.actions.d/againFilter.sh"
        '';

        xdg.configFile."todofish.conf".text = ''
          ROFI_BIN="$(command -v rofi_run)"
          EDITOR="{{terminal}} -e vim"
          SHORTCUT_NEW="Alt+a"
          SHORTCUT_DONE="Alt+d"
          SHORTCUT_EDIT="Alt+e"
          SHORTCUT_SWITCH="Alt+Tab"
          SHORTCUT_TERM="Alt+t"
          SHORTCUT_FILTERS="Alt+p"
          SHORTCUT_CLEAR="Alt+c"
          SHORTCUT_HELP="Super+h"
          TODOFI_CMD_DO="do"
          export TODO_NO_AGAIN_IF_NOT_TAGGED=1
          '';

        # Sync notes service
        systemd.user.services.notes-sync = {
          Unit = { Description = "Sync notes"; };
          Service = {
            CPUSchedulingPolicy = "idle";
            IOSchedulingClass = "idle";
            Environment = "SSH_AUTH_SOCK=/run/user/1000/gnupg/S.gpg-agent.ssh";
            ExecStart = toString (
              pkgs.writeShellScript "notes-sync" ''
                set -e
                ${pkgs.busybox}/bin/nc -z github.com 22
                DATE=$(${pkgs.coreutils}/bin/date)
                ${pkgs.git}/bin/git -C ~/Notes pull
                ${pkgs.git}/bin/git -C ~/Notes add .
                ${pkgs.git}/bin/git -C ~/Notes commit -m "Auto commit + push. $DATE" || exit 0
                ${pkgs.git}/bin/git -C ~/Notes push
              ''
              );
            };
          };
          systemd.user.timers.notes-sync = {
            Unit = { Description = "Sync notes"; };
            Timer = {
              Unit = "notes-sync.service";
              OnCalendar = "hourly";
              Persistent = true;
            };
            Install = { WantedBy = [ "timers.target" ]; };
          };
        };
    }
