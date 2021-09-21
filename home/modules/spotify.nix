{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.home.gui;
  sound = config.home.sound;
in
{
  config = mkIf (gui.enable && sound.enableSpotify) {
      home.packages = with pkgs; [
        playerctl
        spotify
      ];
  };
}
