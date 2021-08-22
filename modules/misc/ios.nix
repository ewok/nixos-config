{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.misc.ios;
  username = config.properties.user.name;
in
{
  options.modules.misc.ios = {
    enable = mkEnableOption "Enable ios soft.";
  };
  config = mkIf cfg.enable {
    services.usbmuxd.enable = true;
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        libimobiledevice
      ];
    };
  };
}
