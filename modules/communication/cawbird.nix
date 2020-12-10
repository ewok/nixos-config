{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  comm = config.modules.communication;
  username = config.properties.user.name;
in
{
  config = mkIf (gui.enable && comm.enable) {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        cawbird
      ];
    };
  };
}

