{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.misc.android;
  username = config.properties.user.name;
in
{
  options.modules.misc.android = {
    enable = mkEnableOption "Enable android soft.";
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        android-tools
      ];
    };
  };
}
