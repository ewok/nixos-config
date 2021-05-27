{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  cfg = config.modules.edu;
  username = config.properties.user.name;
in
{
  options.modules.edu = {
    enable = mkEnableOption "Enable edu soft.";
  };
  config = mkIf (cfg.enable && gui.enable) {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        anki
        goldendict
      ];
    };
  };
}
