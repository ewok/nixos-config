{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.home.dev;
  gui = config.home.gui;
  fonts = config.home.theme.fonts;
in
{
  config = mkIf (dev.enable && gui.enable) {
    home.packages = [
      # pkgs.typora
      pkgs.obsidian
    ];

    # xdg.configFile."Typora/conf/conf.user.json".text = builtins.toJSON {
    #   "defaultFontFamily" = {
    #     "standard" = null;
    #     "serif" = null;
    #     "sansSerif" = null;
    #     "monospace" = fonts.monospaceFont;
    #   };

    #   "autoHideMenuBar" = false;

    #   "searchService" = [
    #     [ "Search with Google" "https://google.com/search?q=%s" ]
    #   ];
    #   "keyBinding" = {
    #     "Always on Top" = "Ctrl+Shift+P";
    #   };
    #   "monocolorEmoji" = false;
    #   "autoSaveTimer" = 3;
    #   "maxFetchCountOnFileList" = 500;
    #   # default [], append Chrome launch flags, e.g: [["disable-gpu"], ["host-rules", "MAP * 127.0.0.1"]]
    #   "flags" = [];
    # };
  };
}
