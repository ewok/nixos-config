{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.terminal;
  colors = cfg.colors;
  terminal = cfg.terminal;
  fonts = cfg.fonts;
in
{
  options.opt.terminal = {
    enable = mkOption { type = types.bool; };
    username = mkOption {type = types.str;};
    terminal = mkOption {type = types.str;};

    colors = {
      background = mkOption {
        type = types.str;
      };
      foreground = mkOption {
        type = types.str;
      };
      text = mkOption {
        type = types.str;
      };
      cursor = mkOption {
        type = types.str;
      };
        # Black
        color0 = mkOption {
          type = types.str;
        };
        # Red
        color1 = mkOption {
          type = types.str;
        };
        # Green
        color2 = mkOption {
          type = types.str;
        };
        # Yellow
        color3 = mkOption {
          type = types.str;
        };
        # Blue
        color4 = mkOption {
          type = types.str;
        };
        # Magenta
        color5 = mkOption {
          type = types.str;
        };
        # Cyan
        color6 = mkOption {
          type = types.str;
        };
        # White
        color7 = mkOption {
          type = types.str;
        };
        # Br Black
        color8 = mkOption {
          type = types.str;
        };
        # Br Red
        color9 = mkOption {
          type = types.str;
        };
        # Br Green
        color10 = mkOption {
          type = types.str;
        };
        # Br Yellow
        color11 = mkOption {
          type = types.str;
        };
        # Br Blue
        color12 = mkOption {
          type = types.str;
        };
        # Br Magenta
        color13 = mkOption {
          type = types.str;
        };
        # Br Cyan
        color14 = mkOption {
          type = types.str;
        };
        # Br White
        color15 = mkOption {
          type = types.str;
        };
      };

      fonts = {
        dpi = mkOption {
          type = types.int;
          description = "Font DPI.";
        };
        regularFont = mkOption {
          type = types.str;
          description = "Default regular font.";
        };
        regularFontSize = mkOption {
          type = types.int;
          description = "Default regular font size.";
        };
        monospaceFont = mkOption {
          type = types.str;
          description = "Default monospace font.";
        };
        monospaceFontSize = mkOption {
          type = types.int;
          description = "Default monospace font size.";
        };
        consoleFont = mkOption {
          type = types.str;
          description = "Default console font.";
        };
      };
  };

  config = mkIf cfg.enable {
      # home.packages = with pkgs; [ (nerdfonts.override { fonts = [ "FiraCode" "FiraMono" ]; }) ];
      programs.alacritty = {
        enable = (terminal == "alacritty");
        settings = {
          scrolling = {
            history = 100000;
          };
          font = {
            normal = {
              family = fonts.monospaceFont;
              style = "Regular";
            };
            size = fonts.monospaceFontSize;
          };
          colors = {
            primary = {
              background = "0x${colors.background}";
              foreground = "0x${colors.foreground}";
            };
            normal = {
              black = "0x${colors.color0}";
              red = "0x${colors.color1}";
              green = "0x${colors.color2}";
              yellow = "0x${colors.color3}";
              blue = "0x${colors.color4}";
              magenta = "0x${colors.color5}";
              cyan = "0x${colors.color6}";
              white = "0x${colors.color7}";
            };
            bright = {
              black = "0x${colors.color8}";
              red = "0x${colors.color9}";
              green = "0x${colors.color10}";
              yellow = "0x${colors.color11}";
              blue = "0x${colors.color12}";
              magenta = "0x${colors.color13}";
              cyan = "0x${colors.color14}";
              white = "0x${colors.color15}";
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
        package = pkgs.hello;
        settings = {
          font_family = fonts.monospaceFont;
          font_size = fonts.monospaceFontSize;
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
        font = "${fonts.monospaceFont} ${toString fonts.monospaceFontSize}";
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
}
