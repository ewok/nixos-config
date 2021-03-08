{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
in
  {
    config = mkIf gui.enable {
      home-manager.users.${username} = {
        home.packages = with pkgs; [
          calibre
          epr
        ];
      };
    };
  }



