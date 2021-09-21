{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.home.dev;
  gui = config.home.gui;
in
{
  config = mkIf (dev.enable && gui.enable && dev.dbtools.enable) {
    home.packages = with pkgs; [ dbeaver ];
  };
}
