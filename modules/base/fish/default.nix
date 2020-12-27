{ config, lib, pkgs, ... }:
with lib;
let
  base = config.modules.base;
  dev = config.modules.dev;
  username = config.properties.user.name;
  tz = config.properties.timezone;
  open = pkgs.writeShellScriptBin "open" ''
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
  fish-tmux = pkgs.writeShellScriptBin "fish-tmux" ''
    if [[ -z "$TMUX" ]]
    then
      SESS=$(tmux list-sessions | grep -v attached | cut -d: -f1 | head -n 1)
      if [[ -n "$SESS" ]]
      then
        tmux attach -t $SESS
      else
        tmux new
      fi
    fi
  '';
in
{
  config = mkIf base.enable {

    home-manager.users."${username}" = {

      home.packages = [ open fish-tmux ];

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
          kgpof = ''kubectl get pod --field-selector="status.phase==Failed"'';
          krmpof = ''kubectl delete pod --field-selector="status.phase==Failed"'';
        };

        shellAliases = {
          exit = "sync;sync;sync;clear;builtin exit";
          ll = "ls -la --color";
          ls = "ls -a --color";
        };

        functions = {
          "nix-my-clean-result" = {
            body = ''
              if string match -q -- "-f" $argv
                echo "Deleting..."
                nix-store --gc --print-roots | awk '{print $1}' | grep '/result$' | sudo xargs rm
              else
                nix-store --gc --print-roots | awk '{print $1}' | grep '/result$' | sudo xargs echo
                echo
                echo "To delete run:"
                echo "nix-my-clean-result -f"
              end
            '';
          };
          "vifm" = {
            body = ''
              set -l dst (command vifm --choose-dir - $argv)
              if test -z "$dst"
                echo 'Directory picking cancelled/failed'
                return 1
              end
              cd "$dst"
            '';
          };
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
          fish-tmux
        '';
        loginShellInit = ''
          curl 'wttr.in?1nq' -m 0.5
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
            set -gx TERMINAL /usr/bin/kitty
            set -gx VISUAL 'nvim'
            set -gx XDG_CONFIG_HOME "$HOME/.config"

            set fish_greeting
            __git.reset
          '';
        };

        xdg.configFile = mkMerge [
          {
            "fish/conf.d/my_git_abbr.fish".source = ./config/conf.d/my_git_abbr.fish;
            "fish/functions/ssh-agent.fish".source = ./config/functions/ssh-agent.fish;
          }
          (optionalAttrs (dev.k8s.enable) {
            "fish/functions/fish_right_prompt.fish".source = ./config/functions/fish_right_prompt.fish;
          })
        ];
      };
    };
  }

