{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.direnv;
in
{
  options.opt.direnv = {
    enable = mkEnableOption "direnv";
  };

  config = mkIf cfg.enable {

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    home.packages = with pkgs; [
        direnv
        nix-direnv
    ];

    xdg.configFile."fish/conf.d/99_direnv.fish" = {
      text = ''
        if status --is-interactive; or status --is-login
          #if command -vq -- direnv
            direnv hook fish | source
            function __direnv_export_eval --on-event fish_prompt;
                begin;
                    begin;
                        "${pkgs.direnv}/bin/direnv" export fish
                    end 1>| source
                end 2>| grep -E -v -e "^direnv: export"
            end;
          #end
        end
      '';
    };
  };
}

