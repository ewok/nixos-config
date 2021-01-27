{ config, lib, pkgs, inputs, ... }:
with lib;
let
  dev = config.modules.dev;
  gui = config.modules.gui;
  username = config.properties.user.name;
in
{
  config = mkIf (dev.enable && gui.enable) {
    home-manager.users."${username}" = {
      home.packages = with pkgs; [ dbeaver ];
    };
  };
}

