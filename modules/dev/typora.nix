{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.modules.dev;
  gui = config.modules.gui;
  username = config.properties.user.name;
in
{
  config = mkIf (dev.enable && gui.enable) {

    home-manager.users."${username}" = {
      home.packages = [ pkgs.typora ];

      xdg.configFile."Typora/conf/conf.user.json".text = builtins.toJSON {
        "defaultFontFamily" = {
          "standard" = null;
          "serif" = null;
          "sansSerif" = null;
          "monospace" = last (reverseList gui.fonts.monospaceFont);
        };

        "autoHideMenuBar" = false;

        "searchService" = [
          [ "Search with Google" "https://google.com/search?q=%s" ]
        ];
        "keyBinding" = {
          "Always on Top" = "Ctrl+Shift+P";
        };
        "monocolorEmoji" = false;
        "autoSaveTimer" = 3;
        "maxFetchCountOnFileList" = 500;
        # default [], append Chrome launch flags, e.g: [["disable-gpu"], ["host-rules", "MAP * 127.0.0.1"]]
        "flags" = [];
      };
    };
  };
}
