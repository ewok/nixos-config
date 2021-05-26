{ config, lib, pkgs, inputs, ... }:
with lib;
let
  dev = config.modules.dev;
  gui = config.modules.gui;
  username = config.properties.user.name;
in
{
  options.modules.dev = {
    dbtools = {
      enable= mkEnableOption "Enable dbtools in dev environment.";
    };
  };
  config = mkIf (dev.enable && gui.enable && dev.dbtools.enable) {
    home-manager.users."${username}" = {
      home.packages = with pkgs; [ dbeaver ];
    };
  };
}
