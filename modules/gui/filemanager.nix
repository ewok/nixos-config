{ config, lib, pkgs, inputs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
  master = import inputs.master (
    {
      config = config.nixpkgs.config;
      localSystem = { system = "x86_64-linux"; };
    }
  );
in
{
  config = mkIf gui.enable {
    environment.systemPackages = with master; [ lxqt.lxqt-policykit ];
    networking.firewall.extraCommands = "iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns";
    services.gvfs.enable = true;
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        pcmanfm
      ];
      xdg.configFile."pcmanfm/default".source = ./pcmanfm;
    };
  };
}
