{ config, lib, pkgs, inputs, ... }:
with lib;
let
  dev = config.modules.dev;
  username = config.properties.user.name;
in
{
  options.modules.dev = {
    java = {
      enable= mkEnableOption "Enable java in dev environment.";
    };
  };
  config = mkIf (dev.enable && dev.java.enable) {
    home-manager.users."${username}" = {
      home.packages = [ pkgs.jdk ];
    };
  };
}
