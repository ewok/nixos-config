{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.home;
in
{
  config = mkIf (cfg.backup.enable && cfg.gui.enable) {
    home.packages = with pkgs; [
      cryptomator
    ];
  };
}
