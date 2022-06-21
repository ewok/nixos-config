{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.shell;

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

  tm = pkgs.writeScriptBin "tm" ''
    #!${pkgs.bash}/bin/bash
    if [[ $1 == "" ]];then
      SESSION="main"
    else
      SESSION="$1"
    fi
    tmux attach -t $SESSION || tmux new -s $SESSION
  '';

  tssh = pkgs.writeScriptBin "tssh" ''
    #!${pkgs.bash}/bin/bash
    argv=( "$@" )
    C=1
    tmux new-window "ssh ''${argv[0]}"
    for i in "''${argv[@]:1}";do
    tmux split-window -h "ssh $i"
    C=$((C + 1))
    done
    if [ "$#" -gt 4 ];then
    tmux select-layout tiled
    else
    tmux select-layout even-vertical
    fi
  '';

in
  {
    options.opt.shell = {

      awsEnable = mkOption { type = types.bool; };
      k8sEnable = mkOption { type = types.bool; };

      tz = mkOption {
        type = types.str;
      };

      username = mkOption {type = types.str;};
    };

    config = {
        home.packages = with pkgs; [
          bat
          binutils
          curl
          dfc
          exa
          fasd
          fd
          file
          global
          htop
          inetutils
          jq
          netcat
          nix-tree
          ntfs3g
          open
          openssl
          pciutils
          reptyr
          ripgrep
          silver-searcher
          tm
          tmate
          trash-cli
          tree
          tssh
          unzip
          usbutils
          viddy
          wget
          wipe
          zip
        ];

        #home.file.".profile".text = ''
        #  umask 0077
        #'';

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
          TZ = cfg.tz;

          XDG_CONFIG_HOME = "$HOME/.config";
        };

        programs.fish = {
          enable = true;

          shellAbbrs = {
            vim = "nvim";
            mproc = "smem -t -k -c pss -P";
            egrep = "egrep --color=always";
          };

          shellAliases = {
            exit = "sync;sync;sync;clear;builtin exit";
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
        {
          name = "fasd";
          src = pkgs.fetchFromGitHub {
            owner = "fishgretel";
            repo = "fasd";
            rev = "9a16eddffbec405f06ac206256b0f7e3112b0e2c";
            sha256 = "15pfvqsfm5d54szprqc973864v2zpx1hy782hpcfgg0gqmxm4ad7";
          };
        }
      ];

      interactiveShellInit = ''

          if functions -vq -- fenv
            fenv source ~/.profile
          end

          # {readFile ./config/fish/functions/ssh-agent.fish}
          bind \cw backward-kill-word

          if ! test -z "$TMUX"
            if test -t 2
                systemctl --state=failed --no-legend --no-pager >&2
                systemctl --user --state=failed --no-legend --no-pager >&2
                if command -vq -- t
                  t ls
                end
            end
          end

          if command -vq -- tmux
            if test -n "$INSIDE_EMACS"
              set TMUX_CMD tmux -L emacs
            else
              set TMUX_CMD "tmux"
            end

            if test -z "$TMUX"
              set -l SESS ($TMUX_CMD list-sessions | grep -v attached | cut -d: -f1 | head -n 1)
              echo $SESS
              if test -n "$SESS"
                if $TMUX_CMD attach -t $SESS
                  exit
                end
              else
                if $TMUX_CMD new
                  exit
                end
              end
            end
          end

          bind \cw backward-kill-word
          bind \e\cB backward-bigword
          bind \e\cF forward-bigword
          bind \e\[109\;5u execute

          if command -vq -- viddy
            alias watch viddy
          end

          if command -vq -- exa
            alias ll "exa -la --git"
            alias ls "exa -a --git"
          end

          if command -vq -- bat
            alias cat "bat"
          end
      '';

      loginShellInit = ''
         if functions -vq -- fenv
           fenv source ~/.profile
         end

        set -Ux ABBR_TIPS_PROMPT "\n💡 \e[1m{{ .abbr }}\e[0m => {{ .cmd }}"
        set -Ux ABBR_TIPS_ALIAS_WHITELIST # Not set
        set -Ux ABBR_TIPS_REGEXES '(^(\w+\s+)+(-{1,2})\w+)(\s\S+)' '(^( ?\w+){3}).*' '(^( ?\w+){2}).*' '(^( ?\w+){1}).*'
        set -Ux FZF_LEGACY_KEYBINDINGS 0
        set -Ux OPEN_CMD open
        set -U fish_greeting
        __abbr_tips_init
      '';
    };

    xdg.configFile = mkMerge [
      {
        "fish/conf.d/my_git_abbr.fish".source = ./config/fish/conf.d/my_git_abbr.fish;
      }
      (
        optionalAttrs (cfg.k8sEnable) {
          "fish/functions/fish_right_prompt.fish".source = ./config/fish/functions/fish_right_prompt.fish;
      })
      (
        optionalAttrs (cfg.awsEnable) {
          "fish/conf.d/aws_completer.fish".text = ''
          complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
          '';
        })
      ];

      programs.starship = {
        enable = true;
        enableFishIntegration = true;

        settings = {

          add_newline = false;
          scan_timeout = 10;

          battery = {
            display = [
              {
                style = "bold red";
                threshold = 15;
              }
              {
                style = "bold yellow";
                threshold = 30;
              }
            ];
          };

          character = {
            error_symbol = "[λ](bold red)";
            success_symbol = "[λ](bold green)";
            vicmd_symbol = "[λ](bold blue)";
          };

          directory = {
            truncation_length = 8;
            truncation_symbol = "…/";
          };

          gcloud.format = "on [($symbol$project)]($style) ";

          git_status = {
            modified = "*";
            renamed = "R";
          };

          status = {
            disabled = false;
            format = "[\[$symbol$status\]]($style) ";
            style = "bg:blue";
          };

          conda.disabled = true;
          dotnet.disabled = true;
          elixir.disabled = true;
          elm.disabled = true;
          erlang.disabled = true;
          nodejs.disabled = true;
          ocaml.disabled = true;
          php.disabled = true;
        };
      };

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      programs.fzf = {
        enable = true;
        enableFishIntegration = true;
        # enableZshIntegration = true;
        defaultCommand = "rg --hidden --no-ignore --files";
      };

      programs.tmux = {
        enable = true;
        terminal = "screen-256color";
        baseIndex = 1;
        keyMode = "vi";
        clock24 = true;
        escapeTime = 0;
        historyLimit = 100000;
        plugins = with pkgs.tmuxPlugins;
          [
            yank
          ];
        extraConfig = builtins.readFile ./config/tmux.conf;
      };
  };
}
