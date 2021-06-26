{ config, lib, pkgs, inputs, ... }:
with lib;
let
  gui = config.modules.gui;
  colors = config.properties.theme.colors;
  terminal = config.properties.defaultTerminal;
  username = config.properties.user.name;
  master = import inputs.master (
    {
      config = config.nixpkgs.config;
      localSystem = { system = "x86_64-linux"; };
    }
  );
  # blurlock = pkgs.writeShellScriptBin "blurlock" ''
  #   ${pkgs.xkb-switch}/bin/xkb-switch -s us
  #   RESOLUTION=$(${pkgs.xorg.xrandr}/bin/xrandr -q|sed -n 's/.*current[ ]\([0-9]*\) x \([0-9]*\),.*/\1x\2/p')
  #   ${pkgs.imagemagick}/bin/import -silent -window root jpeg:- | ${pkgs.imagemagick}/bin/convert - -scale 20% -blur 0x2.5 -resize 500% RGB:- | \
  #     ${pkgs.i3lock}/bin/i3lock --raw $RESOLUTION:rgb -i /dev/stdin -e $@
  #     ${pkgs.i3lock}/bin/i3lock -c 121212
  # '';
  blurlock = pkgs.writeShellScriptBin "blurlock" ''
    ${pkgs.xkb-switch}/bin/xkb-switch -s us
    ${pkgs.i3lock}/bin/i3lock -c 121212
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
  config = mkIf gui.enable {
    services.xserver = {
      enable = true;
      windowManager = {
        i3 = {
          enable = true;
          package = pkgs.i3-gaps;
        };
      };

      displayManager = {
        autoLogin = { enable = true; user = "${username}"; };
        defaultSession = "none+i3";
        sessionCommands = ''
          setxkbmap -rules "evdev" -model "pc105" -layout "us,ru" -option "ctrl:swapcaps"
        '';
      };
    };

    environment.sessionVariables.CURRENT_WM = [ "i3" ];

    # Themes
    environment.variables = {
      GTK_THEME = "Adwaita:dark";
    };
    environment.systemPackages = with pkgs; [
      plymouth
    ];

    qt5 = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    services.dbus.packages = [ pkgs.gnome3.dconf ];

    home-manager.users.${username} = {

      xdg.mimeApps.enable = true;
      home.packages = with pkgs; [
        imagemagick
        xdotool
        xorg.xrandr
        xorg.xwininfo
        xorg.xkill
        colorpicker

        gnome3.libsecret

        blurlock
        i3exit

        font-awesome

        lm_sensors

      ] ++ [ master.xkb-switch-i3 ];

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
          "alacritty"
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
          "${terminal}"
        ] (readFile ./config/config);
      };
      # (readFile ./config/config);
      xdg.configFile."i3/rotate.sh".source = ./config/rotate.sh;

      programs.i3status-rust = {
        enable = true;
        package = master.i3status-rust;
        bars = {
          default = {
            settings = {
              icons = {
                name = "awesome";
                overrides = {
                  time = "";
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
              # {
              #   block = "time";
              #   interval = 60;
              #   format = "📆 %a %d %b 🏠 %R";
              #   timezone = "Europe/Moscow";
              # }
              # {
              #   block = "time";
              #   interval = 60;
              #   format = "🌐 %R";
              #   timezone = "UTC";
              # }
              # {
              #   block = "time";
              #   interval = 60;
              #   format = "🌏 %R";
              #   timezone = "Asia/Manila";
              # }

              {
                block = "custom";
                command = pkgs.writeShellScript "show-date.sh" ''
                  LOCAL=$(date +"📆 %a %d %b 🏠 %R")
                  UTC=$(date -u +"🌐 %R")
                  ASIA=$(TZ='Asia/Manila' date +"🌏 %R")
                  echo "$LOCAL $UTC $ASIA"
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

              (
                mkIf (config.fileSystems ? "/mnt/Data") {
                  block = "disk_space";
                  path = "/mnt/Data";
                  # alias = " data";
                  format = " data {available}";
                  info_type = "available";
                  unit = "GB";
                  interval = 60;
                  warning = 10.0;
                  alert = 5.0;
                }
              )

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
              {
                block = "networkmanager";
                on_click = "alacritty -e nmtui";
                interface_name_exclude = [
                  "br\\-[0-9a-f]{12}"
                  "docker\\d+"
                  "wlp[0-9a-f]+"
                  "enp[0-9a-f]+"
                ];
                interface_name_include = [];
                ap_format = "{ssid^3}";
                device_format = "{icon}{name:0^4}";
              }
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
                block = "custom";
                command = "xkb-switch";
                interval = 10;
                signal = 4;
              }
            ];
            icons = "awesome";
            theme = "solarized-dark";
          };
        };
      };

      # gtk-color-scheme = "bg_color:#282c34\nfg_color:#abb2bf\nbase_color:#282c34\ntext_color:#abb2bf\nselected_bg_color:#3e4451\nselected_fg_color:#abb2bf\ntooltip_bg_color:#282c34\ntooltip_fg_color:#565c64\ntitlebar_bg_color:#282c34\ntitlebar_fg_color:#61afef\nmenubar_bg_color:#282c34\nmenubar_fg_color:#61afef\ntoolbar_bg_color:#282c34\ntoolbar_fg_color:#e5c07b\nmenu_bg_color:#282c34\nmenu_fg_color:#abb2bf\npanel_bg_color:#282c34\npanel_fg_color:#98c379\nlink_color:#d19a66"
      gtk = {
        enable = true;
        font = {
          name = "FiraCode Nerd Font Mono 10";
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
    };
  };
}
