{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.home.gui;
  gaming = config.home.misc.gaming;
in
{
  config = mkIf (gui.enable && gaming.enable) {
    home.packages = with pkgs; [
      steam
    ];
  };
}
