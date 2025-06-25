{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;

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
      nvd
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
    xdg.configFile."nushell/autoload/direnv.nu" = {
      text = ''
        $env.config.hooks.env_change.PWD = (
            $env.config.hooks.env_change.PWD | append { ||
              if (which direnv | is-empty) {
                  return
              }
              direnv export json | from json | default {} | load-env
              $env.PATH = $env.PATH | split row (char env_sep)
          }
        )
      '';
    };
  };
}
