{ config, lib, pkgs, ... }:
with lib;
let
  base = config.modules.base;
  gui = config.modules.gui;
  username = config.properties.user.name;
in
{
  config = mkMerge [
    (
      mkIf base.enable {

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

          xdg.configFile."vifm/vifmrc".text = ''
            ${readFile ./config/vifmrc}
            ${readFile ./config/colors/onedark.vifm}
            ${readFile ./config/plugins/devicons.vifm}
            ${readFile ./config/vifm_commands}
            ${readFile ./config/vifm_keys}
            ${readFile ./config/vifm_ext}
            ${readFile ./config/vifm_custom}
            '';

          # xdg.configFile."vifm/colors/theme.vifm".source = ./config/colors/onedark.vifm;
          # xdg.configFile."vifm/plugins/devicons.vifm".source = ./config/plugins/devicons.vifm;
          xdg.configFile."vifm/scripts".source = ./config/scripts;
          # xdg.configFile."vifm/vifm_commands".source = ./config/vifm_commands;
          # xdg.configFile."vifm/vifm_custom".source = ./config/vifm_custom;
          # xdg.configFile."vifm/vifm_ext".source = ./config/vifm_ext;
          # xdg.configFile."vifm/vifm_keys".source = ./config/vifm_keys;
        };
      }
    )

    (
      mkIf (base.enable && gui.enable) {
        home-manager.users."${username}" = {
          programs.zathura.enable = true;

          xdg.mimeApps.defaultApplications = lib.genAttrs [
            "application/pdf"
            "application/cbz"
            "application/cbr"
            "image/vnd.djvu"
          ] (_: [ "org.pwmt.zathura.desktop" ]) // lib.genAttrs [
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
      }
    )
  ];
}
