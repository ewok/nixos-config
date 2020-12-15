{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.modules.dev;
  gui = config.modules.gui;
  username = config.properties.user.name;
in
{
  config = mkIf (dev.enable && gui.enable) {
    home-manager.users."${username}" = {
      home.packages = [ pkgs.sparkleshare pkgs.git-lfs ];
    };
  };
}

