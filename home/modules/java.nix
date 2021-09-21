{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.home.dev;
in
{
  config = mkIf (dev.enable && dev.java.enable) {
    home.packages = [ pkgs.jdk ];
  };
}
