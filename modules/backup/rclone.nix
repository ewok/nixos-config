{ config, lib, pkgs, ... }:
with lib;
let
  backup = config.modules.backup;
  username = config.properties.user.name;
in
{
  config = mkIf backup.enable {
    environment.systemPackages = [ pkgs.rclone ];
  };
}
