{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.home.gui;
  cfg = config.home.misc.edu;
in
{
  config = mkIf (cfg.enable && gui.enable) {
    home.packages = with pkgs; [
      anki
      goldendict
    ];
  };
}
