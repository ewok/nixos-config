{ config, lib, pkgs, ... }:
with lib;
let
  nm = config.networking.networkmanager;
  username = config.opt.network.username;
  deviceName = config.opt.network.deviceName;
  gui = config.opt.network.gui;
in
{
  options.opt.network = {
      username = mkOption {
        description = "Username.";
        type = types.str;
      };

      deviceName = mkOption {
        description = "Device name.";
        type = types.str;
      };

      gui = mkOption { type = types.bool; };
  };

  config = mkMerge [
    (
      {
        networking.hostName = "${deviceName}";
        networking.networkmanager.enable = true;
        networking.enableIPv6 = false;
        boot.kernel.sysctl."net.ipv6.conf.all.disable_ipv6" = true;
        boot.kernel.sysctl."net.ipv6.conf.enp0s31f6.disable_ipv6" = true;
        boot.kernel.sysctl."net.ipv6.conf.wlp0s20f3.disable_ipv6" = true;
        services.usbmuxd.enable = true;
        environment.systemPackages = with pkgs; [
          libimobiledevice
        ];
      }
    )
    (
      mkIf (gui && nm.enable) {
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
