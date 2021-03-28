{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  gaming = config.modules.gaming;
  username = config.properties.user.name;
in
{
  options.modules.gaming = {
    enable = mkEnableOption "Enable gaming soft.";
  };

  config = mkIf (gui.enable && gaming.enable) {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        steam
        discord
      ];
    };
  };
}
