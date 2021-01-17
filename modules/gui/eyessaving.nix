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
            day = 5500;
            night = 3900;
          };
        };
      };
    };
  }
