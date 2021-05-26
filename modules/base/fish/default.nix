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
              rev = "eb02787e19f24e926789ac497493b87e6e50b0a2";
              sha256 = "02465j23x0cxfja1ycq8k1slwd6fd25jhr6llma5wpd5b577vhw8";
            };
          }
          {
            name = "fish-abbr";
            src = pkgs.fetchFromGitHub {
              owner = "Gazorby";
              repo = "fish-abbreviation-tips";
              rev = "71662df06da763d3d38d93706555beb2ffce22e3";
              sha256 = "01dwx85h8zv7r5155034ic0bdy7w4pghx3sz0z6sxr2pm9zb8jlw";
            };
          }
          {
            name = "kubectl";
            src = pkgs.fetchFromGitHub {
              owner = "evanlucas";
              repo = "fish-kubectl-completions";
              rev = "bbe3b831bcf8c0511fceb0607e4e7511c73e8c71";
              sha256 = "1r6wqvvvb755jkmlng1i085s7cj1psxmddqghm80x5573rkklfps";
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
            if [[ -n "$TMUX" ]]
            then
              systemctl --state=failed --no-legend --no-pager &
              systemctl --user --state=failed --no-legend --no-pager &
              if ! pgrep zoom > /dev/null;then
                # if [[ $(t lsp | tee /dev/stderr | wc -l) -eq 0 ]];then
                  t ls
                # fi
              fi
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
        in
          ''
            ${readFile ./config/functions/ssh-agent.fish}
            set -Ux FZF_LEGACY_KEYBINDINGS 0
            set -Ux OPEN_CMD open
            bind \cw backward-kill-word
            set -Ux ABBR_TIPS_PROMPT "\n💡 \e[1m{{ .abbr }}\e[0m => {{ .cmd }}"
            set -Ux ABBR_TIPS_ALIAS_WHITELIST # Not set
            set -Ux ABBR_TIPS_REGEXES '(^(\w+\s+)+(-{1,2})\w+)(\s\S+)' '(^( ?\w+){3}).*' '(^( ?\w+){2}).*' '(^( ?\w+){1}).*'
            ${startup-script}
          '';

        loginShellInit = ''
          set fish_greeting
          __git.reset
          __abbr_tips_init.fish
        '';
      };

      xdg.configFile = mkMerge [
        {
          "fish/conf.d/my_git_abbr.fish".source = ./config/conf.d/my_git_abbr.fish;
        }
        (
          optionalAttrs (dev.k8s.enable) {
            "fish/functions/fish_right_prompt.fish".source = ./config/functions/fish_right_prompt.fish;
          }
        )
        (
          optionalAttrs (dev.aws.enable) {
            "fish/conf.d/aws_completer.fish".text = ''
              complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
            '';
          }
        )
      ];
    };
  };
}
