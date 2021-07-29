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

    environment.loginShellInit = ''
      if [ -e $HOME/.profile ]
      then
        . $HOME/.profile
      fi
    '';

    environment.pathsToLink = [ "/share/zsh" ];

    home-manager.users."${username}" = {

      home.packages = [
        open
      ];

      home.file.".profile".text = ''
        umask 0077
      '';

      programs.autojump = {
        enable = true;
        enableZshIntegration = true;
      };

      home.sessionVariables = {
        LANG = "en_US.UTF-8";
        # LC_CTYPE "ru_RU.UTF-8"
        LC_NUMERIC = "ru_RU.UTF-8";
        LC_TIME = "en_US.UTF-8";
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

      programs.zsh = {
        enable = true;
        dotDir = ".config/zsh";
        history = {
          save = 100000;
          size = 100000;
          expireDuplicatesFirst = true;
          ignoreSpace = false;
        };

        initExtra = ''
          export WORDCHARS=""
          autoload -U select-word-style
          select-word-style normal

          vifm()
          {
            local dst="$(command vifm --choose-dir - "$@")"
            if [ -z "$dst" ]; then
              echo 'Directory picking cancelled/failed'
              return 1
            fi
            cd "$dst"
          }
          ${readFile ./aliases.sh}
        '';

        envExtra = ''
          export OPEN_CMD=open
          export FZF_LEGACY_KEYBINDINGS=0
          export _git_log_medium_format='%C(bold)Commit:%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'
          export _git_log_oneline_format='%C(green)%h%C(reset) %s%C(red)%d%C(reset)%n'
          export _git_log_brief_format='%C(green)%h%C(reset) %s%n%C(blue)(%ar by %an)%C(red)%d%C(reset)%n'
          export _git_status_ignore_submodules=all
        '';

        # initExtraBeforeCompInit = ''
        # '';

        initExtraFirst = ''
          if [[ -n "$TMUX" ]]
          then
            systemctl --state=failed --no-legend --no-pager
            systemctl --user --state=failed --no-legend --no-pager
            #if ! pgrep zoom > /dev/null;then
              # if [[ $(t lsp | tee /dev/stderr | wc -l) -eq 0 ]];then
               t ls
              # fi
            #fi
          else
            SESS=$(tmux list-sessions | grep -v attached | cut -d: -f1 | head -n 1)
            if [[ -n "$SESS" ]]
            then
              tmux attach -t $SESS && exit
            else
              tmux new && exit
            fi
          fi
        '';

        # localVariables = {
        #   POWERLEVEL9K_LEFT_PROMPT_ELEMENTS = [ "dir" "vcs" ];
        # };

        # loginExtra = ''
        # '';

        # logoutExtra = ''
        # '';

        plugins =
          [
            {
              name = "zsh-autosuggestion";
              file = "zsh-autosuggestions.plugin.zsh";
              src = pkgs.fetchFromGitHub {
                owner = "zsh-users";
                repo = "zsh-autosuggestions";
                rev = "v0.7.0";
                sha256 = "1g3pij5qn2j7v7jjac2a63lxd97mcsgw6xq6k5p7835q9fjiid98";
              };
            }
            {
              name = "zsh-completion";
              file = "zsh-completions.plugin.zsh";
              src = pkgs.fetchFromGitHub {
                owner = "zsh-users";
                repo = "zsh-completions";
                rev = "0.33.0";
                sha256 = "0vs14n29wvkai84fvz3dz2kqznwsq2i5fzbwpv8nsfk1126ql13i";
              };
            }
            {
              name = "zsh-syntax";
              file = "zsh-syntax-highlighting.plugin.zsh";
              src = pkgs.fetchFromGitHub {
                owner = "zsh-users";
                repo = "zsh-syntax-highlighting";
                rev = "0.7.1";
                sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
              };
            }
            {
              name = "zsh-async";
              file = "async.plugin.zsh";
              src = pkgs.fetchFromGitHub {
                owner = "mafredri";
                repo = "zsh-async";
                rev = "v1.8.5";
                sha256 = "09wlqghxczndmzpr5hgqlf90yhbbi4mh8k0179arplikgbfd75cs";
              };
            }
            {
              name = "abbrev-alias";
              file = "abbrev-alias.plugin.zsh";
              src = pkgs.fetchFromGitHub {
                owner = "momo-lab";
                repo = "zsh-abbrev-alias";
                rev = "master";
                sha256 = "0gcc9017yyz0kf7lwqaqgaxw23pl5icwsx44w4fkhx8whqn5yxw1";
              };
            }
            {
              name = "you-should-use";
              file = "you-should-use.plugin.zsh";
              src = pkgs.fetchFromGitHub {
                owner = "MichaelAquilina";
                repo = "zsh-you-should-use";
                rev = "1.7.3";
                sha256 = "1dz48rd66priqhxx7byndqhbmlwxi1nfw8ik25k0z5k7k754brgy";
              };
            }
            # completions
            {
              name = "nix-completion";
              file = "nix-zsh-completions.plugin.zsh";
              src = pkgs.fetchFromGitHub {
                owner = "spwhitt";
                repo = "nix-zsh-completions";
                rev = "0.4.4";
                sha256 = "1n9whlys95k4wc57cnz3n07p7zpkv796qkmn68a50ygkx6h3afqf";
              };
            }

          ];

        prezto = {
          enable = true;

          pmodules = [
            "environment"
            "terminal"
            "editor"
            "history"
            "directory"
            "spectrum"
            "utility"
            "tmux"
            # "git"
            "completion"
            "prompt"
          ];

        };

        shellAliases = {
          k = "kubectl";
          kx = "kubectx";
          ke = "kubens";
          tf = "terraform";
          tg = "terragrunt";
          h = "helm";
          mproc = "smem -t -k -c pss -P";
          egrep = "egrep --color=always";
          kgpof = ''kubectl get pod --field-selector="status.phase==Failed"'';
          krmpof = ''kubectl delete pod --field-selector="status.phase==Failed"'';

          exit = "sync;sync;sync;clear;builtin exit";
          # ll = "ls -la --color";
          # ls = "ls -a --color";
          ll = "exa -la --git";
          ls = "exa -a --git";
          cat = "bat";
          rm = "trash-put";
        };

      };
    };
  };
}
