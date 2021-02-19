{ config, lib, pkgs, ... }:
with lib;
let
  base = config.modules.base;
  gui = config.modules.gui;
  username = config.properties.user.name;
in
  {
    config = mkMerge [
      (mkIf base.enable {

        home-manager.users."${username}" = {
          home.packages = with pkgs; [
            vifm
            unzip
            p7zip
            sshfs
            curlftpfs
            ts
            archivemount
            dpkg
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
      })

      (mkIf (base.enable && gui.enable) {
        home-manager.users."${username}" = {
          programs.zathura.enable = true;

          xdg.mimeApps.defaultApplications = lib.genAttrs [
            "application/pdf"
            "application/cbz"
            "application/cbr"
            "image/vnd.djvu"
          ] (_: [ "org.pwmt.zathura.desktop" ]) //

          lib.genAttrs [
            "image/png"
            "image/jpg"
            "image/jpeg"
          ] (_: [ "viewnior.desktop" ]);

          home.packages = with pkgs; [
            ffmpeg
            imagemagick
            viewnior
          ];
        };
      })
    ];
  }
