{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;

  autocutseld = pkgs.writeScript "autocutseld" ''
    #!${pkgs.bash}/bin/bash
    set -ex

    ${pkgs.autocutsel}/bin/autocutsel -selection CLIPBOARD &
    PID1=$!
    ${pkgs.autocutsel}/bin/autocutsel -selection PRIMARY &
    PID2=$!

    cleanup(){
    echo "***Stopping"
    kill -15 $PID1
    kill -15 $PID2

    wait $PID1 $PID2
    }
    trap 'cleanup' 1 2 3 6 15
    wait $PID1 $PID2
  '';
in
{
  config = mkIf gui.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        autocutsel
      ];

      systemd.user.services.autocutseld = {
        Unit = {
          Description = "auto synchronize clipboards";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        Service = {
          Type = "simple";
          ExecStart = "${autocutseld}";
          Restart = "on-failure";
        };

        Install = { WantedBy = [ "graphical-session.target" ]; };
      };

      systemd.user.services.autocutseld-restart = {
        Unit = { Description = "restart autocutseld"; };
        Service = {
          Type = "simple";
          ExecStart = "/run/current-system/sw/bin/systemctl --user --no-block restart autocutseld.service";
        };
      };
      systemd.user.timers.autocutseld-restart = {
        Unit = { Description = "restart autocutseld"; };
        Timer = {
          Unit = "autocutseld-restart.service";
          OnCalendar = "daily";
          Persistent = true;
        };
        Install = { WantedBy = [ "timers.target" ]; };
      };
      # xdg.configFile."clipit/clipitrc" = {
      #   text = ''
      #     [rc]
      #     use_copy=true
      #     use_primary=true
      #     synchronize=true
      #     automatic_paste=false
      #     show_indexes=false
      #     save_uris=true
      #     use_rmb_menu=false
      #     save_history=false
      #     history_limit=50
      #     items_menu=20
      #     statics_show=true
      #     statics_items=10
      #     hyperlinks_only=false
      #     confirm_clear=false
      #     single_line=true
      #     reverse_history=false
      #     item_length=50
      #     ellipsize=2
      #     history_key=<Ctrl><Alt>H
      #     actions_key=<Ctrl><Alt>A
      #     menu_key=<Ctrl><Alt>P
      #     search_key=<Ctrl><Alt>F
      #     offline_key=<Ctrl><Alt>O
      #     offline_mode=false
      #   '';
      # };
    };
  };
}
