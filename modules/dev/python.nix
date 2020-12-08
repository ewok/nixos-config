{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.modules.dev;
  username = config.properties.user.name;
in
{
  config = mkIf dev.enable {
    home-manager.users."${username}" = {
      home.packages = with pkgs; [
        python3
        python3Packages.virtualenv
      ];
    };
  };
}
