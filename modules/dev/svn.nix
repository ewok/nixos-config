{ config, lib, pkgs, inputs, ... }:
with lib;
let
  dev = config.modules.dev;
  username = config.properties.user.name;
in
{
  config = mkIf dev.enable {
    home-manager.users."${username}" = {
      home.packages = with pkgs; [ subversionClient ];
    };
  };
}