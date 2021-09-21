{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.home.gui;
  cfg = config.home.misc.books;
in
{
  config = mkIf (cfg.enable && gui.enable) {
    home.packages = with pkgs; [
      calibre
      epr
    ];
  };
}
