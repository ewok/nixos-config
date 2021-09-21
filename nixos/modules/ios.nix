{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixos.ios;
  username = config.nixos.username;
in
{
  config = mkIf cfg.enable {
    services.usbmuxd.enable = true;

    home-manager.users.${username} = {
      home.packages = with pkgs; [
        libimobiledevice
      ];
    };
  };
}
