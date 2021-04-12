{ config, lib, pkgs, inputs, ... }:
with lib;
let
  gui = config.modules.gui;
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
    environment.systemPackages = [ pkgs.herbstluftwm ];
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

      ] ++ [ master.xkb-switch-i3 ];

      xdg.configFile."i3/config".source = ./config/config;
      xdg.configFile."i3/rotate.sh".source = ./config/rotate.sh;

      programs.i3status-rust = {
        enable = true;
        bars = {
          default = {
            settings = {
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
                block = "time";
                interval = 60;
                format = "MSK: %a %d/%m %R";
                timezone = "Europe/Moscow";
              }
              {
                block = "time";
                interval = 60;
                format = "LDN: %R";
                timezone = "Europe/London";
              }
              {
                block = "time";
                interval = 60;
                format = "NY: %R";
                timezone = "America/New_York";
              }
              {
                block = "time";
                interval = 60;
                format = "PST: %R";
                timezone = "America/Los_Angeles";
              }
              {
                block = "disk_space";
                path = "/";
                alias = "/";
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
                  alias = "/Data";
                  info_type = "available";
                  unit = "GB";
                  interval = 60;
                  warning = 10.0;
                  alert = 5.0;
                }
              )

              {
                block = "cpu";
                interval = 1;
              }
              {
                block = "memory";
                display_type = "memory";
                format_mem = "{Mum}MB({Mup}%)";
                format_swap = "{SUm}MB({SUp}%)";
                icons = true;
                clickable = true;
                interval = 10;
                warning_mem = 80;
                warning_swap = 80;
                critical_mem = 95;
                critical_swap = 95;
              }
              {
                block = "music";
                player = "spotify";
                buttons = [ "play" "next" ];
              }
              {
                block = "sound";
                step_width = 5;
              }
              {
                block = "battery";
                interval = 60;
                format = "{percentage}% {time}";
              }
              {
                block = "custom";
                command = "xkb-switch";
                interval = 5;
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
      };
    };
  };
}
