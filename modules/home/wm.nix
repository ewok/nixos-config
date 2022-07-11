{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.wm;
  colors = cfg.colors;

  centerMouse = pkgs.writeShellScriptBin "center-mouse" ''
    XDT=${pkgs.xdotool}/bin/xdotool

    WINDOW=`$XDT getwindowfocus`

    eval `${pkgs.xdotool}/bin/xdotool getwindowgeometry --shell $WINDOW`

    TX=`expr $WIDTH / 2`
    TY=`expr $HEIGHT / 2`

    $XDT mousemove -window $WINDOW $TX $TY
  '';
  blurlock = pkgs.writeShellScriptBin "blurlock" ''
    set -e
    ${pkgs.xkb-switch}/bin/xkb-switch -s us
    i3lock -c 121212
  '';
  i3exit = pkgs.writeShellScriptBin "i3exit" ''
    case "$1" in
      lock)
          ${blurlock}/bin/blurlock
          ;;
      logout)
          ${pkgs.i3}/bin/i3-msg exit
          ;;
      switch_user)
          dm-tool switch-to-greeter
          ;;
      suspend)
          ${blurlock}/bin/blurlock && systemctl suspend
          ;;
      hibernate)
          ${blurlock}/bin/blurlock && systemctl hibernate
          ;;
      reboot)
          systemctl reboot
          ;;
      shutdown)
          systemctl poweroff
          ;;
      *)
          echo "== ! i3exit: missing or invalid argument ! =="
          echo "Try again with: lock | logout | switch_user | suspend | hibernate | reboot | shutdown"
          exit 2
    esac
  '';
in
{
  options.opt.wm = {
    enable = mkOption { type = types.bool; };
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

    terminal = mkOption {
      description = "Default terminal";
      type = types.str;
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

      displayProfiles = mkOption {
        type = types.lines;
        default = "{}";
      };

      displayHooks = mkOption {
        type = types.lines;
        default = "{}";
      };
  };

  config = mkIf cfg.enable {

      # Base directories
      home.file."Documents/.keep".text = "";
      home.file."Downloads/.keep".text = "";
      home.file."mnt/.keep".text = "";
      home.file."Pictures/.keep".text = "";
      home.file."Pictures/Screenshots/.keep".text = "";
      home.file."share/.keep".text = "";
      home.file."tmp/.keep".text = "";

      xdg.mimeApps.enable = true;

      home.packages = with pkgs; [
        xdotool
        xorg.xrandr
        xorg.xwininfo
        xorg.xkill
        colorpicker

        libsecret

        blurlock
        i3exit
        centerMouse

        font-awesome

        lm_sensors
        (nerdfonts.override { fonts = [ "FiraCode" "FiraMono" ]; })

        pcmanfm
        caffeine-ng

        scrot
        flameshot
        peek
        feh

        alsa-utils

        nixgl.nixGLIntel

        light

        pavucontrol
        ponymix

      ] ++ [ pkgs.xkb-switch-i3 ];


      xdg.configFile."i3/config" = {
        text = replaceStrings [
          "set $base00 #000000"
          "set $base01 #000000"
          "set $base02 #000000"
          "set $base03 #000000"
          "set $base04 #000000"
          "set $base05 #000000"
          "set $base06 #000000"
          "set $base07 #000000"
          "set $base08 #000000"
          "set $base09 #000000"
          "set $base0A #000000"
          "set $base0B #000000"
          "set $base0C #000000"
          "set $base0D #000000"
          "set $base0E #000000"
          "set $base0F #000000"
          "{{terminal}}"
          "%REGULAR_FONT%"
          "%REGULAR_FONT_SIZE%"
          "%MONO_FONT%"
          "%MONO_FONT_SIZE%"
        ] [
          "set $base00 #${colors.color0}"
          "set $base01 #${colors.color10}"
          "set $base02 #${colors.color11}"
          "set $base03 #${colors.color8}"
          "set $base04 #${colors.color12}"
          "set $base05 #${colors.color7}"
          "set $base06 #${colors.color13}"
          "set $base07 #${colors.color15}"
          "set $base08 #${colors.color1}"
          "set $base09 #${colors.color9}"
          "set $base0A #${colors.color3}"
          "set $base0B #${colors.color2}"
          "set $base0C #${colors.color6}"
          "set $base0D #${colors.color4}"
          "set $base0E #${colors.color5}"
          "set $base0F #${colors.color14}"
          "${cfg.terminal}"
          "${cfg.fonts.regularFont}"
          "${toString cfg.fonts.regularFontSize}"
          "${cfg.fonts.monospaceFont}"
          "${toString (cfg.fonts.monospaceFontSize - 3)}"
        ] (readFile ./config/wm/config);
      };
      xdg.configFile."i3/rotate.sh".source = ./config/wm/rotate.sh;
      xdg.configFile."i3/i3-strict".source = ./config/wm/i3-strict.sh;
      xdg.configFile."i3/center-mouse".source = ./config/wm/center-mouse.sh;
      xdg.configFile."pcmanfm/default".source = ./config/pcmanfm;

      programs.i3status-rust = {
        enable = true;
        package = pkgs.i3status-rust;
        bars = {
          default = {
            settings = {
              icons = {
                name = "awesome";
                overrides = {
                  time = "";
                  volume_muted = "🔇";
                  volume_empty = "🔈";
                  volume_half = "🔉";
                  volume_full = "🔊";
                };
              };

              theme = {
                name = "solarized-dark";
                overrides = {
                  idle_bg = "#3e4451";
                  idle_fg = "#abb2bf";
                  info_bg = "#56b6c2";
                  info_fg = "#282c34";
                  good_bg = "#98c379";
                  good_fg = "#282c34";
                  warning_bg = "#e5c07b";
                  warning_fg = "#282c34";
                  critical_bg = "#e06c75";
                  critical_fg = "#282c34";
                  separator = "";
                };
              };
            };
            blocks = [

              {
                block = "custom";
                command = pkgs.writeShellScript "show-date.sh" ''
                  DATE=$(date +"📆 %Y-%m-%d %R")
                  UTC=$(date -u +"🌐 %R")
                  MSK=$(TZ='Europe/Moscow' date +"🇷🇺 %R")
                  PHT=$(TZ='Asia/Manila' date +"🇵🇭 %R")
                  KG=$(TZ='Asia/Bishkek' date +"🇰🇬 %R")
                  echo "$DATE $UTC $MSK $KG $PHT"
                '';
                interval = 60;
              }

              {
                block = "temperature";
                collapsed = false;
                interval = 10;
                format = "{max}";
                chip = "*-isa-*";
                # inputs = ["CPUTIN" "SYSTIN"];
                good = 50;
                idle = 70;
                info = 85;
                warning = 90;
            }

            {
              block = "custom";
              command = pkgs.writeShellScript "show-fans.sh" ''
                FAN_SPEED="$(sensors | grep fan1 | awk '{ print $2}')"
                if [ $FAN_SPEED -gt 0 ]
                then
                  echo '{"state":"Warning", "text": " '$FAN_SPEED'"}'
                else
                  echo '{"state":"Good", "text": "ﴛ"}'
                fi
              '';
              interval = 10;
              json = true;
            }

            {
              block = "disk_space";
              path = "/";
              format = " / {available}";
              info_type = "available";
              unit = "GB";
              interval = 60;
              warning = 20.0;
              alert = 10.0;
            }

            # (
            #   mkIf (config.fileSystems ? "/mnt/Data") {
            #     block = "disk_space";
            #     path = "/mnt/Data";
            #     # alias = " data";
            #     format = " data {available}";
            #     info_type = "available";
            #     unit = "GB";
            #     interval = 60;
            #     warning = 10.0;
            #     alert = 5.0;
            #   }
            # )

            {
              block = "cpu";
              interval = 5;
              format = "{barchart}";
            }
            {
              block = "memory";
              display_type = "memory";
              format_mem = "{mem_used_percents:1}";
              format_swap = "{swap_used_percents:1}";
              icons = true;
              clickable = true;
              interval = 20;
              warning_mem = 80;
              warning_swap = 80;
              critical_mem = 95;
              critical_swap = 95;
            }
            {
              block = "net";
              format = "{speed_down;K*b}{speed_up;K*b}";
              interval = 10;
              hide_inactive = true;
              hide_missing = true;
            }
            # {
            #   block = "networkmanager";
            #   on_click = "${cfg.terminal} -e nmtui";
            #   interface_name_exclude = [
            #     "br\\-[0-9a-f]{12}"
            #     "docker\\d+"
            #     "wlp[0-9a-f]+"
            #     "enp[0-9a-f]+"
            #   ];
            #   interface_name_include = [];
            #   ap_format = "{ssid^3}";
            #   device_format = "{icon}";
            # }
            {
              block = "sound";
              step_width = 5;
            }
            {
              block = "music";
              buttons = [ "play" "next" ];
              format = "{combo}";
              hide_when_empty = true;
              max_width = 5;
            }
            {
              block = "battery";
              interval = 60;
              format = "{percentage} {time}";
            }
            {
              block = "backlight";
            }
            {
              block = "keyboard_layout";
              driver = "xkbswitch";
              on_click = "xkb-switch -n";
              format = "{layout} {variant}";
              interval = 1;
            }
          ];
          icons = "awesome";
          theme = "solarized-dark";
        };
      };
    };

    gtk = {
      enable = true;
      font = {
        name = "${cfg.fonts.regularFont} ${toString cfg.fonts.regularFontSize}";
      };
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
      theme = {
        name = "Adwaita-dark";
        package = pkgs.adwaita-qt;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-theme-name = "Adwaita-dark";
      };
    };
    qt = {
      enable = true;
      platformTheme = "gnome";
      # style = "adwaita-dark";
      style = {
        name = "Adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };

    services.screen-locker = {
      enable = true;
      lockCmd = "${blurlock}/bin/blurlock";
      inactiveInterval = 5;
    };

    # Fonts
    xresources.properties = {
      "Xft.antialias" = true;
      "Xft.autohint" = false;
      "Xft.dpi" = "${toString cfg.fonts.dpi}";
      "Xft.hinting" = true;
      "Xft.hintstyle" = "hintmedium";
      };

      programs.autorandr = {
        enable = true;
        profiles = builtins.fromJSON cfg.displayProfiles;
        hooks = builtins.fromJSON cfg.displayHooks;
      };

      # Notifications
      services.dunst = {
        enable = true;
        iconTheme = {
          name = "Papirus";
          package = pkgs.papirus-icon-theme;
        };
        settings = {
          global = {
            alignment = "left";
            ellipsize = "middle";
            format = ''%s %p\n%b'';
            geometry = "0x4-25+25";
            hide_duplicate_count = false;
            horizontal_padding = 10;
            idle_threshold = 120;
            ignore_newline = false;
            indicate_hidden = true;
            line_height = 0;
            markup = "full";
            notification_height = 0;
            padding = 8;
            separator_height = 1;
            show_age_threshold = 60;
            show_indicators = true;
            shrink = false;
            sort = true;
            stack_duplicates = true;
            transparency = 15;
            vertical_alignment = "center";
            word_wrap = true;

            icon_position = "left";
            min_icon_size = 0;
            max_icon_size = 64;

            sticky_history = true;
            history_length = 20;
            always_run_script = true;

            title = "Dunst";
            class = "Dunst";

            startup_notification = false;
            verbosity = "mesg";

            corner_radius = 0;
            ignore_dbusclose = false;

            mouse_left_click = "close_current";
            mouse_middle_click = "do_action, close_current";
            mouse_right_click = "close_all";

            frame_color = "#${colors.color7}";
            separator_color = "#${colors.color7}";
            font = "Monospace 10";
            follow = "mouse";
            browser = "xdg-open";
          };
          shortcuts = {
            history = "ctrl+shift+n";
          };

          urgency_low = {
            background = "#${colors.color10}";
            foreground = "#${colors.color7}";
            timeout = 5;
          };
          urgency_normal = {
            background = "#${colors.color11}";
            foreground = "#${colors.color3}";
            timeout = 10;
          };
          urgency_critical = {
            background = "#${colors.color1}";
            foreground = "#${colors.color0}";
          };
        };
      };

      # Wallpaper rotation
      services.random-background = {
        enable = true;
        imageDirectory = "--recursive %h/Pictures/wallpapers";
        display = "fill";
        interval = "8h";
        enableXinerama = true;
      };
      home.file."Pictures/wallpapers/.keep".text = "";

      # Clipboard sync
      systemd.user.services.autocutseld = {
        Unit = {
          Description = "auto synchronize clipboards";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        Service = {
          Type = "simple";
          ExecStart = toString(
              pkgs.writeShellScript "autocutseld" ''
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
              ''
            );
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
  };
}
