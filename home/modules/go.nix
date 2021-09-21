{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.home.dev;
in
{
  config = mkIf (dev.enable && dev.go.enable) {
      home.packages = [ pkgs.go ];
    };
}
