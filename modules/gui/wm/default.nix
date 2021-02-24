{ config, lib, pkgs, inputs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
  master = import inputs.master ({
    config = config.nixpkgs.config;
    localSystem = { system = "x86_64-linux"; };
  });
  blurlock = pkgs.writeShellScriptBin "blurlock" ''
    ${pkgs.xkb-switch}/bin/xkb-switch -s us
    RESOLUTION=$(${pkgs.xorg.xrandr}/bin/xrandr -q|sed -n 's/.*current[ ]\([0-9]*\) x \([0-9]*\),.*/\1x\2/p')
    ${pkgs.imagemagick}/bin/import -silent -window root jpeg:- | ${pkgs.imagemagick}/bin/convert - -scale 20% -blur 0x2.5 -resize 500% RGB:- | \
      ${pkgs.i3lock}/bin/i3lock --raw $RESOLUTION:rgb -i /dev/stdin -e $@
  '';
  i3exit = pkgs.writeShellScriptBin "i3exit" ''
    case "$1" in
      lock)
          ${blurlock}/bin/blurlock
          ;;
      logout)
          i3-msg exit
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
          defaultSession = "none+i3";
          sessionCommands = ''
            setxkbmap -rules "evdev" -model "pc105" -layout "us,ru" -option "ctrl:swapcaps"
          '';
        };

      };
      environment.sessionVariables.CURRENT_WM = [ "i3" ];
      environment.variables = {
        GTK_THEME = "Adwaita:dark";
      };

      qt5 = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
      };

      services.dbus.packages = [ pkgs.gnome3.dconf ];

      services.gnome3.gnome-keyring.enable = true;
      programs.seahorse.enable = true;
      security.pam.services.lightdm.enableGnomeKeyring = true;

      home-manager.users.${username} = {

        xdg.mimeApps.enable = true;

        home.packages = with pkgs; [
          imagemagick
          xdotool
          xorg.xrandr
          xorg.xwininfo

          gnome3.libsecret

          blurlock
          i3exit
        ] ++ [ master.xkb-switch-i3 ];

        xdg.configFile."i3/config".source = ./config/config;
        xdg.configFile."i3/rotate.sh".source = ./config/rotate.sh;

        programs.i3status-rust = {
          enable = true;
          bars.default = {
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

               (mkIf (config.fileSystems ? "/mnt/Data") {
                 block = "disk_space";
                 path = "/mnt/Data";
                 alias = "/Data";
                 info_type = "available";
                 unit = "GB";
                 interval = 60;
                 warning = 10.0;
                 alert = 5.0;
               })

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
                 buttons = ["play" "next"];
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
             theme = "bad-wolf";
           };
         };

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
         };

         services.screen-locker = {
           enable = true;
           lockCmd = "${blurlock}/bin/blurlock";
         };
       };
     };
   }
