{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  sound = config.modules.system.sound;
  username = config.properties.user.name;
in
{
  config = mkIf (gui.enable && sound.enable) {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        playerctl
        spotify
      ];
    };
  };
}
