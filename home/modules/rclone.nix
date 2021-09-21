{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.home;
in
{
  config = mkIf cfg.backup.enable {
    home.packages = [ pkgs.rclone ];
  };
}
