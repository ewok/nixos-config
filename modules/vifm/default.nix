{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.vifm;
  open = pkgs.writeShellScriptBin "open" ''
    #!/usr/bin/env bash
        if [[ "$WSLENV" != "" ]]; then
            explorer.exe "$@"
        elif [[ "$OSTYPE" == "linux-gnu" ]]; then
            xdg-open "$@"
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            /usr/bin/open "$@"
        elif [[ "$OSTYPE" == "cygwin" ]]; then
            exit 1
        elif [[ "$OSTYPE" == "msys" ]]; then
            exit 1
        elif [[ "$OSTYPE" == "freebsd"* ]]; then
            exit 1
        else
            exit 1
        fi
  '';
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
      open
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
