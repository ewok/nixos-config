{ config, lib, pkgs, ... }:
with lib;
let
  base = config.modules.base;
  username = config.properties.user.name;
in
{
  config = mkIf base.enable {

    home-manager.users."${username}" = {

      home.packages = with pkgs; [
        vifm
        unzip
        p7zip
        sshfs
        curlftpfs
        ts
        archivemount
      ];

      xdg.configFile."vifm/colors".source = ./config/colors;
      xdg.configFile."vifm/plugins".source = ./config/plugins;
      xdg.configFile."vifm/scripts".source = ./config/scripts;
      xdg.configFile."vifm/vifm_commands".source = ./config/vifm_commands;
      xdg.configFile."vifm/vifm_custom".source = ./config/vifm_custom;
      xdg.configFile."vifm/vifm_ext".source = ./config/vifm_ext;
      xdg.configFile."vifm/vifm_keys".source = ./config/vifm_keys;
      xdg.configFile."vifm/vifmrc".source = ./config/vifmrc;
    };
  };
}
