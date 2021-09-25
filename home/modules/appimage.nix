{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.home.gui;
in
{
  config = mkIf gui.enable {
    home.packages = with pkgs; [
      appimage-run
    ];
  };
}
