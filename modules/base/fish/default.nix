{ config, lib, pkgs, ... }:
with lib;
let
  base = config.modules.base;
  dev = config.modules.dev;
  username = config.properties.user.name;
  tz = config.properties.timezone;
in
{
  config = mkIf base.enable {

    home-manager.users."${username}" = {

      programs.fish = {
        enable = true;

        shellAbbrs = {
          vim = "nvim";
          k = "kubectl";
          kx = "kubectx";
          ke = "kubens";
          tf = "terraform";
          tg = "terragrunt";
          h = "helm";
          mproc = "smem -t -k -c pss -P";
          egrep = "egrep --color=always";
          j = "jrnl";
        };

        plugins = [
          {
            name = "git";
            src = pkgs.fetchFromGitHub {
              owner = "jhillyerd";
              repo = "plugin-git";
              rev = "ac95cd71e961dbe6fc4c15d539a34c42247623f6";
              sha256 = "sjNDQn66M+RB42aYBEE3MUy9MWcPFdKt5w6P/e5WZE8=";
            };
          }
          {
            name = "fish-abbr";
            src = pkgs.fetchFromGitHub {
              owner = "Gazorby";
              repo = "fish-abbreviation-tips";
              rev = "0be97640909fb20de51ff9ed9bcbda0bd2b28b36";
              sha256 = "QhedoSwlenuRbnd20rdfTEesV8X2IhzefB7bbmUGVq8=";
            };
          }
          {
            name = "kubectl";
            src = pkgs.fetchFromGitHub {
              owner = "evanlucas";
              repo = "fish-kubectl-completions";
              rev = "da5fa3c0dc254d37eb4b8e73a86d07c7bcebe637";
              sha256 = "7pR5/aQCkHct9lBx3u3nHmCAuo/V7XN1lC+ZvlRnNCo=";
            };
          }
        ];

        interactiveShellInit = ''
          set -Ux FZF_LEGACY_KEYBINDINGS 0
          set -Ux OPEN_CMD open
          bind \cw backward-kill-word
          '';
        loginShellInit = ''
          set -x LANG en_US.UTF-8
          # set -x LC_CTYPE "ru_RU.UTF-8"
          set -x LC_NUMERIC "ru_RU.UTF-8"
          set -x LC_TIME "ru_RU.UTF-8"
          set -x LC_COLLATE "ru_RU.UTF-8"
          set -x LC_MONETARY "ru_RU.UTF-8"
          # set -x LC_MESSAGES "ru_RU.UTF-8"
          set -x LC_PAPER "ru_RU.UTF-8"
          set -x LC_NAME "ru_RU.UTF-8"
          set -x LC_ADDRESS "ru_RU.UTF-8"
          set -x LC_TELEPHONE "ru_RU.UTF-8"
          set -x LC_MEASUREMENT "ru_RU.UTF-8"
          set -x LC_IDENTIFICATION "ru_RU.UTF-8"
          set -x LC_ALL

          set -gx TERM screen-256color;

          set -gx PATH $HOME/bin $HOME/.local/bin $PATH
          set -gx TZ '' + tz + ''

          set -gx BROWSER /usr/bin/firefox
          set -gx EDITOR 'nvim'
          set -gx GUI_EDITOR /usr/bin/nvim
          set -gx TERMINAL /usr/bin/termite
          set -gx VISUAL 'nvim'
          set -gx XDG_CONFIG_HOME "$HOME/.config"

          set fish_greeting
          '';

        shellAliases = {
          exit = "sync;sync;sync;clear;builtin exit";
          # git = "LANGUAGE=en_US.UTF-8 command git $argv";
          ll = "ls -la --color";
          ls = "ls -a --color";
          kgpof = ''kubectl get pod --field-selector="status.phase==Failed"'';
          krmpof = ''kubectl delete pod --field-selector="status.phase==Failed"'';
        };
      };


      xdg.configFile = mkMerge [
        {
          "fish/conf.d/my_git_abbr.fish".source = ./config/conf.d/my_git_abbr.fish;
          "fish/functions/vifm.fish".source = ./config/functions/vifm.fish;
          "fish/functions/ssh-agent.fish".source = ./config/functions/ssh-agent.fish;
        }
        (optionalAttrs (dev.k8s.enable) {
          "fish/functions/fish_right_prompt.fish".source = ./config/functions/fish_right_prompt.fish;
        })
      ];
    };
  };
}

