{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
in
{
  config = mkIf gui.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        clipit
      ];

      xdg.configFile."clipit/clipitrc".text = ''
        [rc]
        use_copy=true
        use_primary=true
        synchronize=true
        automatic_paste=false
        show_indexes=false
        save_uris=true
        use_rmb_menu=false
        save_history=false
        history_limit=50
        items_menu=20
        statics_show=true
        statics_items=10
        hyperlinks_only=false
        confirm_clear=false
        single_line=true
        reverse_history=false
        item_length=50
        ellipsize=2
        history_key=<Ctrl><Alt>H
        actions_key=<Ctrl><Alt>A
        menu_key=<Ctrl><Alt>P
        search_key=<Ctrl><Alt>F
        offline_key=<Ctrl><Alt>O
        offline_mode=false
      '';
    };
  };
}
