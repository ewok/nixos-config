{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
in
{
  options.modules.gui.office = {
    enable = mkEnableOption "Enable office documents software.";
  };

  config = mkIf (gui.enable && gui.office.enable) {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        libreoffice-fresh
      ];
    };
  };
}
