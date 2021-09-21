{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.home.dev;
in
{
  config = mkIf (dev.enable) {
    home.packages = [ pkgs.awscli2 ];
  };
}
