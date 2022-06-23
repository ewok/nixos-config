{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.appmenu;
  colors = cfg.colors;
  fonts = cfg.fonts;
  terminal = cfg.terminal;

  dmprompt = pkgs.writeShellScriptBin "dmprompt" ''
    [ "$(printf 'No\nYes' \
        | ${rofi_run}/bin/rofi_run -dmenu -p "$1" \
        -i -nb darkred -sb red -sf black -nf gray)" = 'Yes' ] && $2
  '';

  rofiCalc = pkgs.writeShellScriptBin "rofi-calc" ''
    ${rofi_run}/bin/rofi_run -show calc -modi calc -no-show-match -no-sort
  '';

  rofiEmoji = pkgs.writeShellScriptBin "rofi-emoji" ''
    ${rofi_run}/bin/rofi_run -show emoji -modi emoji
  '';

  # dmcalc = pkgs.writeShellScriptBin "calc" ''
  #   dmenucmd="${rofi_run}/bin/rofi_run -dmenu -p Calc $@"
  #
  #   while : ; do
  #       result=$(${pkgs.xsel}/bin/xsel -o -b | $dmenucmd | xargs echo | ${pkgs.bc}/bin/bc -l 2>&1)
  #       if [[ $result ]]; then
  #           printf "$result" | ${pkgs.xsel}/bin/xsel -b
  #       fi
  #       [[ $result ]] || break
  #   done
  # '';

  rofiKill = pkgs.writeShellScriptBin "rofi-kill" ''
    export selected_k="$(ps --user "$(id -u)" -F | \
                ${rofi_run}/bin/rofi_run -dmenu -i -l 20 -p "Search for process to kill:" | \
                awk '{print $2" "$11}')";

    if [[ -n $selected_k ]]; then

        dmprompt "Kill $selected_k?" ${pkgs.writeShellScript "dmkill_helper" ''
    selpid="$(awk '{print $1}' <<< $selected_k)";
    kill -9 $selpid
    echo "Process $selected_k has been killed." && exit 1
  ''}
    fi
  '';

  rofiIP = pkgs.writeShellScriptBin "myip" ''
    dmenucmd="${rofi_run}/bin/rofi_run -dmenu -p MyIP: $@"

    while : ; do
        result=$(${pkgs.curl}/bin/curl ifconfig.me | $dmenucmd)
        if [[ $result ]]; then
            printf "$result" | ${pkgs.xsel}/bin/xsel -b
        fi
        [[ $result ]] || break
    done

  '';

  rofiWithPlugins = pkgs.rofi.override {
      plugins = with pkgs; [
          rofi-calc
          rofi-emoji
      ];
  };

  rofi_run = pkgs.writeShellScriptBin "rofi_run" ''
    ${rofiWithPlugins}/bin/rofi -icon-theme "Papirus" -show-icons -terminal ${terminal} -theme default $@
  '';

  #rofiBluetoothThemed = pkgs.writeShellScriptBin "rofi-bluetooth" ''
  #  #ROFI_THEME=base16-onedark ${pkgs.rofi-bluetooth}/bin/rofi-bluetooth $@
  #  ${pkgs.rofi-bluetooth}/bin/rofi-bluetooth $@
  #'';

in
{
  options.opt.appmenu = {
    enable = mkOption { type = types.bool; };
    username = mkOption {type = types.str;};
    terminal = mkOption {type = types.str;};

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

  };
  config = mkIf cfg.enable {
      home.packages = with pkgs; [
        bc
        rofiCalc
        rofiEmoji
        rofiKill
        rofiIP
        dmprompt
        # rofi
        rofi_run
        # rofiBluetoothThemed
        # rofi-bluetooth
      ];

      # Does not work yet
      xdg.configFile."rofi/colors.rasi".text = ''
          * {
            background: #${colors.color10}ff;
            foreground: #${colors.foreground}ff;
            lightbg:    #${colors.color11}ff;
            lightfg:    #${colors.foreground}ff;
            red:        #${colors.color1}ff;
            blue:       #${colors.color4}ff;
            font:       "${ fonts.regularFont } ${toString fonts.regularFontSize }";
          }
        '';

      xdg.configFile."rofi/default.rasi".text = ''
        @import "colors.rasi"

        * {
            active-background:           @background;
            active-foreground:           @blue;
            alternate-active-background: @lightbg;
            alternate-active-foreground: @blue;
            alternate-normal-background: @lightbg;
            alternate-normal-foreground: @foreground;
            alternate-urgent-background: @lightbg;
            alternate-urgent-foreground: @red;
            background-color:            rgba ( 0, 0, 0, 0 % );
            border-color:                @foreground;
            normal-background:           @background;
            normal-foreground:           @foreground;
            selected-active-background:  @blue;
            selected-active-foreground:  @background;
            selected-normal-background:  @lightfg;
            selected-normal-foreground:  @lightbg;
            selected-urgent-background:  @red;
            selected-urgent-foreground:  @background;
            separatorcolor:              @foreground;
            spacing:                     2;
            urgent-background:           @background;
            urgent-foreground:           @red;
        }
        element {
            padding: 1px ;
            cursor:  pointer;
            spacing: 5px ;
            border:  0;
        }
        element normal.normal {
            background-color: var(normal-background);
            text-color:       var(normal-foreground);
        }
        element normal.urgent {
            background-color: var(urgent-background);
            text-color:       var(urgent-foreground);
        }
        element normal.active {
            background-color: var(active-background);
            text-color:       var(active-foreground);
        }
        element selected.normal {
            background-color: var(selected-normal-background);
            text-color:       var(selected-normal-foreground);
        }
        element selected.urgent {
            background-color: var(selected-urgent-background);
            text-color:       var(selected-urgent-foreground);
        }
        element selected.active {
            background-color: var(selected-active-background);
            text-color:       var(selected-active-foreground);
        }
        element alternate.normal {
            background-color: var(alternate-normal-background);
            text-color:       var(alternate-normal-foreground);
        }
        element alternate.urgent {
            background-color: var(alternate-urgent-background);
            text-color:       var(alternate-urgent-foreground);
        }
        element alternate.active {
            background-color: var(alternate-active-background);
            text-color:       var(alternate-active-foreground);
        }
        element-text {
            background-color: rgba ( 0, 0, 0, 0 % );
            cursor:           inherit;
            highlight:        inherit;
            text-color:       inherit;
        }
        element-icon {
            background-color: rgba ( 0, 0, 0, 0 % );
            size:             1.0000em ;
            cursor:           inherit;
            text-color:       inherit;
        }
        window {
            padding:          5;
            background-color: var(background);
            border:           1;
        }
        mainbox {
            padding: 0;
            border:  0;
        }
        message {
            padding:      1px ;
            border-color: var(separatorcolor);
            border:       2px dash 0px 0px ;
        }
        textbox {
            text-color: var(foreground);
        }
        listview {
            padding:      2px 0px 0px ;
            scrollbar:    true;
            border-color: var(separatorcolor);
            spacing:      2px ;
            fixed-height: 0;
            border:       2px dash 0px 0px ;
        }
        scrollbar {
            width:        4px ;
            padding:      0;
            handle-width: 8px ;
            border:       0;
            handle-color: var(normal-foreground);
        }
        sidebar {
            border-color: var(separatorcolor);
            border:       2px dash 0px 0px ;
        }
        button {
            cursor:     pointer;
            spacing:    0;
            text-color: var(normal-foreground);
        }
        button selected {
            background-color: var(selected-normal-background);
            text-color:       var(selected-normal-foreground);
        }
        num-filtered-rows {
            expand:     false;
            text-color: rgba ( 128, 128, 128, 100 % );
        }
        num-rows {
            expand:     false;
            text-color: rgba ( 128, 128, 128, 100 % );
        }
        textbox-num-sep {
            expand:     false;
            str:        "/";
            text-color: rgba ( 128, 128, 128, 100 % );
        }
        inputbar {
            padding:    1px ;
            spacing:    0px ;
            text-color: var(normal-foreground);
            children:   [ prompt,textbox-prompt-colon,entry,num-filtered-rows,textbox-num-sep,num-rows,case-indicator ];
        }
        case-indicator {
            spacing:    0;
            text-color: var(normal-foreground);
        }
        entry {
            text-color:        var(normal-foreground);
            cursor:            text;
            spacing:           0;
            placeholder-color: rgba ( 128, 128, 128, 100 % );
            placeholder:       "Type to filter";
        }
        prompt {
            spacing:    0;
            text-color: var(normal-foreground);
        }
        textbox-prompt-colon {
            margin:     0px 0.3000em 0.0000em 0.0000em ;
            expand:     false;
            str:        ":";
            text-color: inherit;
        }
      '';

      xresources.extraConfig = ''
        ! Base16 OneDark
        ! Author: Lalit Magant (http://github.com/tilal6991)
        ! base00: #${colors.color0}
        ! base01: #${colors.color10}
        ! base02: #${colors.color11}
        ! base03: #${colors.color8}
        ! base04: #${colors.color12}
        ! base05: #${colors.color7}
        ! base06: #${colors.color13}
        ! base07: #${colors.color15}
        ! base08: #${colors.color1}
        ! base09: #${colors.color9}
        ! base0A: #${colors.color3}
        ! base0B: #${colors.color2}
        ! base0C: #${colors.color6}
        ! base0D: #${colors.color4}
        ! base0E: #${colors.color5}
        ! base0F: #${colors.color14}
        ! Enable the extended coloring options
        rofi.color-enabled: true
        ! Property Name     BG       Border   Separator
        rofi.color-window:  #${colors.color10}, #${colors.color10}, #${colors.color0}
        ! Property Name     BG       FG       BG-alt   Head-BG  Head-FG
        rofi.color-normal:  #${colors.color10}, #${colors.color7}, #${colors.color10}, #${colors.color3}, #${colors.color11}
        rofi.color-active:  #${colors.color10}, #${colors.color4}, #${colors.color10}, #${colors.color3}, #${colors.color4}
        rofi.color-urgent:  #${colors.color10}, #${colors.color1}, #${colors.color10}, #${colors.color3}, #${colors.color1}
        ! Set the desired separator style
        rofi.separator-style: solid
      '';
    };
}
