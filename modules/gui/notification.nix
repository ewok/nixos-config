{ config, lib, pkgs, inputs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
  master = import inputs.master ({
    config = config.nixpkgs.config;
    localSystem = { system = "x86_64-linux"; };
  });
in
  {
    config = mkIf gui.enable {

      home-manager.users.${username} = {
        home.packages = [ master.deadd-notification-center ];

        xdg.configFile."deadd/deadd.conf".source = ./deadd/deadd.conf;
        xdg.configFile."deadd/deadd.css".source = ./deadd/deadd.css;

        systemd.user.services.deadd-notification-center = {
          Unit = {
            Description = "deadd-notification-center";
            After = [ "graphical-session-pre.target" ];
            PartOf = [ "graphical-session.target" ];
          };

          Service = {
            # Type = "forking";
            Type = "dbus";
            BusName = "org.freedesktop.Notifications";
            ExecStart = "${master.deadd-notification-center}/bin/deadd-notification-center";
            Environment = "PATH=${
              makeBinPath
              (with pkgs; [ coreutils glibc ])
            }";
          };

          Install = { WantedBy = [ "graphical-session.target" ]; };
        };
      };
    };
  }

