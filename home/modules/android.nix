{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.home.misc.android;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      android-tools
    ];
  };
}
