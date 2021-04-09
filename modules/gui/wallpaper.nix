{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
in
{
  config = mkIf gui.enable {
    home-manager.users.${username} = {
      services.random-background = {
        enable = true;
        imageDirectory = "--recursive %h/Pictures/wallpapers";
        display = "fill";
        interval = "8h";
        enableXinerama = true;
      };
    };
  };
}
