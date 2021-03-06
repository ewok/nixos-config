{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.modules.dev;
  username = config.properties.user.name;
in
{
  options.modules.dev = {
    go = {
      enable= mkEnableOption "Enable go in dev environment.";
    };
  };
  config = mkIf (dev.enable && dev.go.enable) {
    home-manager.users."${username}" = {
      home.packages = [ pkgs.go ];
    };
  };
}
