{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  cfg = config.modules.books;
  username = config.properties.user.name;
in
{
  options.modules.books = {
    enable = mkEnableOption "Enable books soft.";
  };
  config = mkIf (cfg.enable && gui.enable) {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        calibre
        epr
      ];
    };
  };
}
