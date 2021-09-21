{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.nixos.gui;
  username = config.nixos.username;
in
{
  config = mkIf gui.enable {
    environment.systemPackages = with pkgs; [ lxqt.lxqt-policykit ];
    networking.firewall.extraCommands = "iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns";
    services.gvfs.enable = true;
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        pcmanfm
      ];
      xdg.configFile."pcmanfm/default".source = ./config/pcmanfm;
    };
  };
}
