{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.home.gui;
in
{
  config = mkIf gui.enable {
    services.random-background = {
      enable = true;
      imageDirectory = "--recursive %h/Pictures/wallpapers";
      display = "fill";
      interval = "8h";
      enableXinerama = true;
    };
  };
}
