{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.nixos.gui;
  nm = config.networking.networkmanager;
  username = config.nixos.username;
  deviceName = config.nixos.deviceName;
in
{
  config = mkMerge [
    (
      {
        networking.hostName = "${deviceName}";
        networking.networkmanager.enable = true;
        networking.enableIPv6 = false;
        boot.kernel.sysctl."net.ipv6.conf.all.disable_ipv6" = true;
        boot.kernel.sysctl."net.ipv6.conf.enp0s31f6.disable_ipv6" = true;
        boot.kernel.sysctl."net.ipv6.conf.wlp0s20f3.disable_ipv6" = true;
      }
    )
    (
      mkIf (gui.enable && nm.enable) {
        programs.nm-applet.enable = true;
      }
    )
    (
      mkIf nm.enable {
        users.users.${username}.extraGroups = [ "networkmanager" ];
      }
    )
  ];
}
