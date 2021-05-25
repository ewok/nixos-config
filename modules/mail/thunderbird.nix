{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.mail;
  gui = config.modules.gui;
  username = config.properties.user.name;
in
{
  config = mkIf (cfg.enable && cfg.thunderbird.enable && gui.enable) {
    home-manager.users."${username}" = {
      home.packages = [ pkgs.thunderbird ];
    };
  };
}
