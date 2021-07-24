{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
  colors = config.properties.theme.colors;
  terminal = config.properties.defaultTerminal;
in
{
  config = mkIf gui.enable {

    home-manager.users.${username} = {

      programs.alacritty = {
        enable = (terminal == "alacritty");
        settings = {
          scrolling = {
            history = 100000;
          };
          font = {
            normal = {
              family = gui.fonts.monospaceFont;
              style = "Regular";
            };
            size = gui.fonts.monospaceFontSize;
          };
          colors = {
            primary = {
              background = "0x${colors.background}";
              foreground = "0x${colors.foreground}";
            };
            normal = {
              black =   "0x${colors.color0}";
              red =     "0x${colors.color1}";
              green =   "0x${colors.color2}";
              yellow =  "0x${colors.color3}";
              blue =    "0x${colors.color4}";
              magenta = "0x${colors.color5}";
              cyan =    "0x${colors.color6}";
              white =   "0x${colors.color7}";
            };
            bright = {
              black =   "0x${colors.color8}";
              red =     "0x${colors.color9}";
              green =   "0x${colors.color10}";
              yellow =  "0x${colors.color11}";
              blue =    "0x${colors.color12}";
              magenta = "0x${colors.color13}";
              cyan =    "0x${colors.color14}";
              white =   "0x${colors.color15}";
            };
          };
          cursor = {
            text = "0x${colors.text}";
            cursor = "0x${colors.cursor}";
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
      home.sessionVariables.TERMINAL = "/usr/bin/${terminal}";
      programs.kitty = {
        enable = (terminal == "kitty");
        settings = {
          font_family = gui.fonts.monospaceFont;
          font_size = gui.fonts.monospaceFontSize;
          cursor_shape = "block";
          scrollback_lines = 100000;
          enable_audio_bell = "no";

          background = "#${colors.background}";
          foreground = "#${colors.foreground}";

          color0 = "#${colors.color0}";
          color8 = "#${colors.color8}";

          # red
          color1 = "#${colors.color1}";
          color9 = "#${colors.color9}";

          # green
          color2 = "#${colors.color2}";
          color10 = "#${colors.color10}";

          # yellow
          color3 = "#${colors.color3}";
          color11 = "#${colors.color11}";

          # blue
          color4 = "#${colors.color4}";
          color12 = "#${colors.color12}";

          # magenta
          color5 = "#${colors.color5}";
          color13 = "#${colors.color13}";

          # cyan
          color6 = "#${colors.color6}";
          color14 = "#${colors.color14}";

          # white
          color7 = "#${colors.color7}";
          color15 = "#${colors.color15}";

        };
        keybindings = {
          "shift+enter" = ''send_text all \x1b[13;2u'';
          "ctrl+enter" = ''send_text all \x1b[13;5u'';
        };
        extraConfig = "";
      };
      programs.termite = {
        enable = (terminal == "termite");
        allowBold = true;
        mouseAutohide = true;
        scrollOnKeystroke = true;
        urgentOnBell = true;
        font = "${gui.fonts.monospaceFont} ${toString gui.fonts.monospaceFontSize}";
        fullscreen = true;
        dynamicTitle = true;
        scrollbackLines = 100000;
        browser = "xdg-open";
        cursorBlink = "on";
        cursorShape = "block";
        filterUnmatchedUrls = false;
        modifyOtherKeys = true;
        sizeHints = false;
        scrollbar = "right";

        backgroundColor = "#${colors.background}";
        cursorColor = "#${colors.cursor}";
        cursorForegroundColor = "#${colors.background}";
        foregroundColor = "#${colors.foreground}";
        foregroundBoldColor = "#${colors.foreground}";
        colorsExtra = ''
          # black
          color0 = #${colors.color0}
          color8 = #${colors.color8}

          # red
          color1 = #${colors.color1}
          color9 = #${colors.color9}

          # green
          color2 = #${colors.color2}
          color10 = #${colors.color10}

          # yellow
          color3 = #${colors.color3}
          color11 = #${colors.color11}

          # blue
          color4 = #${colors.color4}
          color12 = #${colors.color12}

          # magenta
          color5 = #${colors.color5}
          color13 = #${colors.color13}

          # cyan
          color6 = #${colors.color6}
          color14 = #${colors.color14}

          # white
          color7 = #${colors.color7}
          color15 = #${colors.color15}

          color16 = #${colors.color9}
          color17 = #${colors.color14}
          color18 = #${colors.color10}
          color19 = #${colors.color11}
          color20 = #${colors.color12}
          color21 = #${colors.color13}
        '';
      };
    };
  };
}
