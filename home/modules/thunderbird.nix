{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.home.mail;
  gui = config.home.gui;
in
{
  config = mkIf (cfg.enable && cfg.thunderbird.enable && gui.enable) {
    home.packages = [ pkgs.thunderbird ];
  };
}
