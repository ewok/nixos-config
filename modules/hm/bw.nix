{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (pkgs) writeScriptBin;

  cfg = config.opt.bw;
  bw-reset = writeScriptBin "bw-reset" ''
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

    home.packages =
      let
        external = with pkgs; [
          bitwarden-cli
        ];
      in
      external ++ [
        bw-reset
      ];

    # TODO: add to nushell config
    xdg.configFile."fish/conf.d/99_bw.fish" = {
      text = ''
        if status --is-interactive
          if command -vq -- bw
            if test -z $GL_BW_SESSION
              set -U GL_BW_SESSION (bw unlock --raw)
            end
            set -x BW_SESSION $GL_BW_SESSION
          fish -N -c 'bw-reset' &
          end
        end
      '';
    };
  };
}
