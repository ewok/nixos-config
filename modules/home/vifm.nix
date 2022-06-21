{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.vifm;
in
{
  options.opt.vifm = {
    gui = mkOption { type = types.bool; };
    username = mkOption {type = types.str;};
  };

  config = mkMerge [
    (
      {
          home.packages = with pkgs; [
            vifm
            unzip
            p7zip
            sshfs
            curlftpfs
            ts
            archivemount
            dpkg
            viu
          ];

          xdg.configFile."vifm/vifmrc".text = ''
            ${readFile ./config/vifm/vifmrc}
            ${readFile ./config/vifm/colors/onedark.vifm}
            ${readFile ./config/vifm/plugins/devicons.vifm}
            ${readFile ./config/vifm/vifm_commands}
            ${readFile ./config/vifm/vifm_keys}
            ${readFile ./config/vifm/vifm_ext}
            ${readFile ./config/vifm/vifm_custom}
          '';

          # xdg.configFile."vifm/colors/theme.vifm".source = ./config/vifm/colors/onedark.vifm;
          # xdg.configFile."vifm/plugins/devicons.vifm".source = ./config/vifm/plugins/devicons.vifm;
          xdg.configFile."vifm/scripts".source = ./config/vifm/scripts;
          # xdg.configFile."vifm/vifm_commands".source = ./config/vifm/vifm_commands;
          # xdg.configFile."vifm/vifm_custom".source = ./config/vifm/vifm_custom;
          # xdg.configFile."vifm/vifm_ext".source = ./config/vifm/vifm_ext;
          # xdg.configFile."vifm/vifm_keys".source = ./config/vifm/vifm_keys;
      }
    )

    (
      mkIf cfg.gui {
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
            ghostscript
            viewnior
          ];
      }
    )
  ];
}
