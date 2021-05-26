{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.modules.dev;
  username = config.properties.user.name;
in
{
  options.modules.dev = {
    terraform = {
      enable= mkEnableOption "Enable terraform in dev environment.";
    };
  };
  config = mkIf (dev.enable) {
    home-manager.users."${username}" = {
      home.packages = [ pkgs.terraform ];
    };
  };
}

