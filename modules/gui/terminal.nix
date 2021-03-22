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
        programs.alacritty = {
          enable = true;
          settings = {
            scrolling = {
              history = 100000;
            };
            font = {
              normal = {
                family = monospaceFont;
                style = "Regular";
              };
              size = gui.fonts.monospaceFontSize;
            };
            colors = {
              primary = {
                background = "#000000";
                foreground = "#ffffff";
              };
              normal = {
                black = "#222222";
                red = "#e84f4f";
                green = "#b7ce42";
                yellow = "#fea63c";
                blue = "#66aabb";
                magenta = "#b7416e";
                cyan = "#6d878d";
                white = "#dddddd";
              };
              bright = {
                black = "#666666";
                red = "#d23d3d";
                green = "#bde077";
                yellow = "#ffe863";
                blue = "#aaccbb";
                magenta = "#e16a98";
                cyan = "#42717b";
                white = "#cccccc";
              };
            };
            cursor = {
              style = "Block";
              blinking = "On";

            };
            key_bindings = [
              {
                key = "Return";
                mods = "Control";
                chars = "\\x1b[13;5u";
              }
              {
                key = "Return";
                mods = "Shift";
                chars = "\\x1b[13;2u";
              }
            ];
          };
        };
        home.sessionVariables.TERMINAL = "/usr/bin/alacritty";
        # programs.kitty = {
        #   enable = true;
        #   settings = {
        #     font_family = monospaceFont;
        #     font_size = gui.fonts.monospaceFontSize;
        #     cursor_shape = "block";
        #     scrollback_lines = 100000;
        #     enable_audio_bell = "no";

        #     background = "#000000";
        #     foreground = "#ffffff";
        #     # black
        #     color0 = "#222222";
        #     color8 = "#666666";

        #     # red
        #     color1 = "#e84f4f";
        #     color9 = "#d23d3d";

        #     # green
        #     color2 = "#b7ce42";
        #     color10 = "#bde077";

        #     # yellow
        #     color3 = "#fea63c";
        #     color11 = "#ffe863";

        #     # blue
        #     color4 = "#66aabb";
        #     color12 = "#aaccbb";

        #     # magenta
        #     color5 = "#b7416e";
        #     color13 = "#e16a98";

        #     # cyan
        #     color6 = "#6d878d";
        #     color14 = "#42717b";

        #     # white
        #     color7 = "#dddddd";
        #     color15 = "#cccccc";
        #   };
        #   keybindings = {
        #     "shift+enter" = ''send_text all \x1b[13;2u'';
        #     "ctrl+enter" = ''send_text all \x1b[13;5u'';
        #   };
        #   extraConfig = "";
        # };
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
