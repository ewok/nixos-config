{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
in
  {
    options.modules.gui = {
      latitude = mkOption {
        type = types.str;
      };
      longitude = mkOption {
        type = types.str;
      };
      day = mkOption {
        type = types.int;
        default = 5500;
      };
      night = mkOption {
        type = types.int;
        default = 3900;
      };
    };

    config = mkIf gui.enable {

      # services.geoclue2 = {
      #   enable = true;
      # };

      home-manager.users.${username} = {
        services.redshift = {
          enable = true;
          latitude = gui.latitude;
          longitude = gui.longitude;
          tray = true;
          temperature = {
            day = gui.day;
            night = gui.night;
          };
        };
      };
    };
  }
