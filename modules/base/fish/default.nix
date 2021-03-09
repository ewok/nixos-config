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
in
{
  config = mkIf base.enable {

    home-manager.users."${username}" = {

      home.packages = [ open ];

      programs.autojump = {
        enable = true;
        enableFishIntegration = true;
      };

      home.sessionVariables = {
        LANG = "en_US.UTF-8";
        # LC_CTYPE "ru_RU.UTF-8"
        LC_NUMERIC = "ru_RU.UTF-8";
        LC_TIME = "ru_RU.UTF-8";
        LC_COLLATE = "ru_RU.UTF-8";
        LC_MONETARY = "ru_RU.UTF-8";
        # LC_MESSAGES "ru_RU.UTF-8"
        LC_PAPER = "ru_RU.UTF-8";
        LC_NAME = "ru_RU.UTF-8";
        LC_ADDRESS = "ru_RU.UTF-8";
        LC_TELEPHONE = "ru_RU.UTF-8";
        LC_MEASUREMENT = "ru_RU.UTF-8";
        LC_IDENTIFICATION = "ru_RU.UTF-8";
        LC_ALL = "";

        TERM = "screen-256color";

        PATH = "$HOME/bin:$HOME/.local/bin:$PATH";
        TZ = tz;

        XDG_CONFIG_HOME = "$HOME/.config";
      };

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
          jrnl = "jrnl";
          kgpof = ''kubectl get pod --field-selector="status.phase==Failed"'';
          krmpof = ''kubectl delete pod --field-selector="status.phase==Failed"'';
        };

        shellAliases = {
          exit = "sync;sync;sync;clear;builtin exit";
          # ll = "ls -la --color";
          # ls = "ls -a --color";
          ll = "exa -la --git";
          ls = "exa -a --git";
          cat = "bat";
          rm = "trash-put";
        };

        functions = {
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
          {
            name = "fenv";
            src = pkgs.fetchFromGitHub {
              owner = "oh-my-fish";
              repo = "plugin-foreign-env";
              rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
              sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
            };
          }
        ];

        interactiveShellInit = let
          startup-script = pkgs.writeShellScript "startup-script.sh" ''
            if [[ ! -z "$TMUX" ]]
            then
              systemctl --state=failed --no-legend
              systemctl --user --state=failed --no-legend
            else
              SESS=$(tmux list-sessions | grep -v attached | cut -d: -f1 | head -n 1)
              if [[ -n "$SESS" ]]
              then
                tmux attach -t $SESS
              else
                tmux new
              fi
            fi
          '';
        in ''
          ${readFile ./config/functions/ssh-agent.fish}
          set -Ux FZF_LEGACY_KEYBINDINGS 0
          set -Ux OPEN_CMD open
          bind \cw backward-kill-word

          ${startup-script}
        '';

        loginShellInit = ''
            set fish_greeting
            __git.reset
          '';
        };

        xdg.configFile = mkMerge [
          {
            "fish/conf.d/my_git_abbr.fish".source = ./config/conf.d/my_git_abbr.fish;
          }
          (optionalAttrs (dev.k8s.enable) {
            "fish/functions/fish_right_prompt.fish".source = ./config/functions/fish_right_prompt.fish;
          })
        ];
      };
    };
  }

