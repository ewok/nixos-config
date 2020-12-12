{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
in
{
  config = mkIf gui.enable {

    services.geoclue2 = {
      enable = true;
    };

    home-manager.users.${username} = {
      services.redshift = {
        enable = true;
        provider = "geoclue2";
        tray = true;
      };
    };

  };
}

