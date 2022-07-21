{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.bw;
  bw-reset = pkgs.writeScriptBin "bw-reset" ''
    #!/usr/bin/env fish

    if bw status 2>/dev/null | grep -q '"locked"'
     set -Ue GL_BW_SESSION
    end
  '';
in
{
  options.opt.bw = {
    enable = mkEnableOption "ssh";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      bitwarden-cli
      # nodePackages_latest.bitwarden-cli
      bw-reset
    ];

    xdg.configFile."fish/conf.d/99_bw.fish" = {
      text = ''
        if status --is-interactive
          if command -vq -- bw
            if test -z $GL_BW_SESSION
              set -U GL_BW_SESSION (bw unlock --raw)
            end
            set -x BW_SESSION $GL_BW_SESSION
          fish -c 'bw-reset' &
          end
        end
      '';
    };
  };
}
