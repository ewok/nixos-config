{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
  blurlock = config.home-manager.users.${username}.xdg.configHome + "/i3/blurlock";
in
  {
    config = mkIf gui.enable {

      services.xserver = {
        enable = true;
        windowManager = {
          i3 = {
            enable = true;
          };
        };
        displayManager = {
          defaultSession = "none+i3";
          sessionCommands = ''
            setxkbmap -rules "evdev" -model "pc105" -layout "us,ru" -option "ctrl:swapcaps"
          '';
        };

      };
      environment.sessionVariables.CURRENT_WM = [ "i3" ];

      services.dbus.packages = [ pkgs.gnome3.dconf ];

      home-manager.users.${username} = {

        home.packages = with pkgs; [
          i3status-rust
          xdotool
          xorg.xwininfo
          imagemagick
          xorg.xrandr
          xkb-switch
        ];

        xdg.configFile."i3/config".source = ./config/config;
        xdg.configFile."i3/mc-win-center.sh".source = ./config/mc-win-center.sh;

        xdg.configFile."i3/blurlock" = {
          text = ''
            #!${pkgs.bash}/bin/bash
            RESOLUTION=$(${pkgs.xorg.xrandr}/bin/xrandr -q|sed -n 's/.*current[ ]\([0-9]*\) x \([0-9]*\),.*/\1x\2/p')
            ${pkgs.imagemagick}/bin/import -silent -window root jpeg:- | ${pkgs.imagemagick}/bin/convert - -scale 20% -blur 0x2.5 -resize 500% RGB:- | \
              ${pkgs.i3lock}/bin/i3lock --raw $RESOLUTION:rgb -i /dev/stdin -e $@
          '';
          executable = true;
        };

        xdg.configFile."i3/i3exit" = {
          text = ''
            #!/usr/bin/env sh
            case "$1" in
              lock)
                  ${blurlock}
                  ;;
              logout)
                  i3-msg exit
                  ;;
              switch_user)
                  dm-tool switch-to-greeter
                  ;;
              suspend)
                  ${blurlock} && systemctl suspend
                  ;;
              hibernate)
                  ${blurlock} && systemctl hibernate
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
          executable = true;
        };

        xdg.configFile."i3status-rust/config.toml".source = ./config/i3status;

        gtk = {
          enable = true;
          font = {
            name = "Noto Sans 10";
          };
          iconTheme = {
            name = "Papirus";
            package = pkgs.papirus-icon-theme;
          };
          theme = {
            name = "Adapta";
            package = pkgs.adapta-gtk-theme;
          };
          gtk3.extraConfig = {
            gtk-application-prefer-dark-theme = true;
          };
        };

        services.screen-locker = {
          enable = true;
          lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 000000";
        };
      };
    };
  }
