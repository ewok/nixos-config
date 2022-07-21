{ config, lib, pkgs, utils, ... }:
with lib;
let
  cfg = config.opt.fish;
  vars = {
    darwin = cfg.darwin;
    linux = !cfg.darwin;
  };
in
{
  options.opt.fish = {
    enable = mkEnableOption "fish";
    darwin = mkOption {
      type = types.bool;
      default = false;
      description = "Enable fish on darwin";
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        fish
        fzf
        zoxide
        eza
        bat
        dfc
        fd
        global
        viddy
        gnutar
        procps

        direnv
        nix-direnv
      ];
      file = {
        # ".profile".source = ./config/profile;
        ".bash_profile".source = ./config/profile;
        ".bashrc".source = utils.templateFile "bashrc" ./config/bashrc vars;
      };
    };
    xdg = {
      configFile = {
        "fish/conf.d/00_pre_init.fish".source = ./config/00_pre_init.fish;
        "fish/conf.d/01_init_interactive.fish".source = ./config/01_init_interactive.fish;
        "fish/conf.d/95_greeting.fish".source = ./config/95_greeting.fish;
        "fish/conf.d/99_zoxide.fish".source = ./config/99_zoxide.fish;
        "fish/fish_plugins".source = ./config/fish_plugins;
        "fish/functions/fisher.fish".source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/jorgebucaran/fisher/HEAD/functions/fisher.fish";
          hash = "sha256-lJvP+FmxQICLFU379pqgTZlYHsjs6XR5V0A+M3iaWGQ=";
        };
        "bash/profile.d/01_path.sh".text = ''
          export PATH=~/.local/bin:~/bin:~/.bin:$PATH

          if [ -z "$HOSTNAME" ] && command -v hostnamectl >/dev/null 2>&1; then
            export HOSTNAME=$(hostnamectl --transient 2>/dev/null)
          fi
          if [ -z "$HOSTNAME" ] && command -v hostname >/dev/null 2>&1; then
            export HOSTNAME=$(hostname 2>/dev/null)
          fi
          if [ -z "$HOSTNAME" ]; then
            export HOSTNAME=$(uname -n)
          fi
        '';
      };
    };
  };
}
