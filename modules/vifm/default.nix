{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.vifm;
in
{
  options.opt.vifm = {
    enable = mkEnableOption "vifm";
  };

  config = mkIf cfg.enable {
    # home-manager.config = {
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

      xdg = {
        configFile = {
          "vifm/vifmrc".text = ''
            ${readFile ./config/vifm/vifmrc}
            ${readFile ./config/vifm/colors/base16.vifm}
            ${readFile ./config/vifm/plugins/devicons.vifm}
            ${readFile ./config/vifm/vifm_commands}
            ${readFile ./config/vifm/vifm_keys}
            ${readFile ./config/vifm/vifm_ext}
            ${readFile ./config/vifm/vifm_custom}
          '';

          "vifm/scripts".source = ./config/vifm/scripts;

          "fish/functions/vifm.fish".text = ''
            function vifm
                set -l dst (command vifm --choose-dir - $argv)
                if test -z "$dst"
                    echo 'Directory picking cancelled/failed'
                    return 1
                end

                cd "$dst"
            end
          '';
        };
      };
    };
  # };
}
