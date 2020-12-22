{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  monospaceFont = last (reverseList gui.fonts.monospaceFont);
  username = config.properties.user.name;
in
  {
    config = mkIf gui.enable {

      home-manager.users.${username} = {
        programs.kitty = {
          enable = true;
          settings = {
            font_family = monospaceFont;
            font_size = gui.fonts.monospaceFontSize;
            cursor_shape = "block";
            scrollback_lines = 100000;
            enable_audio_bell = "no";

            background = "#000000";
            foreground = "#ffffff";
            color0 = "#222222";
            color8 = "#666666";

            # red
            color1 = "#e84f4f";
            color9 = "#d23d3d";

            # green
            color2 = "#b7ce42";
            color10 = "#bde077";

            # yellow
            color3 = "#fea63c";
            color11 = "#ffe863";

            # blue
            color4 = "#66aabb";
            color12 = "#aaccbb";

            # magenta
            color5 = "#b7416e";
            color13 = "#e16a98";

            # cyan
            color6 = "#6d878d";
            color14 = "#42717b";

            # white
            color7 = "#dddddd";
            color15 = "#cccccc";
          };
          keybindings = {

          };
          extraConfig = "";
        };
        # programs.termite = {
        #   enable = true;
        #   allowBold = true;
        #   mouseAutohide = true;
        #   scrollOnKeystroke = true;
        #   urgentOnBell = true;
        #   font = "${monospaceFont} 14";
        #   fullscreen = true;
        #   dynamicTitle = true;
        #   scrollbackLines = 100000;
        #   browser = "xdg-open";
        #   cursorBlink = "on";
        #   cursorShape = "block";
        #   filterUnmatchedUrls = false;
        #   modifyOtherKeys = true;
        #   sizeHints = false;
        #   scrollbar = "right";

        #   backgroundColor = "#000000";
        #   cursorColor = "#dcdccc";
        #   cursorForegroundColor = "#dcdccc";
        #   foregroundColor = "#ffffff";
        #   foregroundBoldColor = "#ffffff";
        #   colorsExtra = ''
        #     # black
        #     color0 = #222222
        #     color8 = #666666

        #     # red
        #     color1 = #e84f4f
        #     color9 = #d23d3d

        #     # green
        #     color2 = #b7ce42
        #     color10 = #bde077

        #     # yellow
        #     color3 = #fea63c
        #     color11 = #ffe863

        #     # blue
        #     color4 = #66aabb
        #     color12 = #aaccbb

        #     # magenta
        #     color5 = #b7416e
        #     color13 = #e16a98

        #     # cyan
        #     color6 = #6d878d
        #     color14 = #42717b

        #     # white
        #     color7 = #dddddd
        #     color15 = #cccccc
        #   '';
        # };
      };
    };
  }
