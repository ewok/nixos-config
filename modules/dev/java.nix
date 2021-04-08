{ config, lib, pkgs, inputs, ... }:
with lib;
let
  dev = config.modules.dev;
  username = config.properties.user.name;
in
{
  config = mkIf (dev.java.enable) {
    home-manager.users."${username}" = {
      home.packages = [ pkgs.jdk ];
    };
  };
}
