{ config, lib, pkgs, inputs, ... }:
with lib;
let
  gui = config.modules.gui;
  backup = config.modules.backup;
  username = config.properties.user.name;
in
{
  config = mkIf gui.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        cryptomator
      ];
    };
  };
}

