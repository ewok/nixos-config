{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf readFile;

  cfg = config.opt.yazi;
  open = pkgs.writeShellScriptBin "open" ''
    #!/usr/bin/env bash
    if [[ "$WSLENV" != "" ]]; then
        explorer.exe "$@"
    elif [[ "$OSTYPE" == "linux-gnu" ]]; then
      if [[ "$ORB" == "true" ]]; then
        mac open "$@"
      else
        /usr/bin/xdg-open "$@"
      fi
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
  xdg-open = pkgs.symlinkJoin {
    name = "xdg-open";
    paths = [ open ];
    postBuild = ''
      ln -s $out/bin/open $out/bin/xdg-open
    '';
  };

  yazi-rs-plugins = builtins.fetchGit {
    url = "https://github.com/yazi-rs/plugins";
    rev = "2301ff803a033cd16d16e62697474d6cb9a94711";
  };

  # yazi-rs-flavors = builtins.fetchGit {
  #   url = "https://github.com/yazi-rs/flavors";
  #   rev = "f6b425a6d57af39c10ddfd94790759f4d7612332";
  # };

  tmux-sp-s = pkgs.writeShellScriptBin "tmux-sp-s" ''
    if [ -n "$TMUX" ]
    then
        tmux split-window -l 20%
    else
        $SHELL
    fi
  '';

  tmux-sp-v = pkgs.writeShellScriptBin "tmux-sp-v" ''
    if [ -n "$TMUX" ]
    then
        I=$(T=$(tty)
        tmux lsp -F'#{pane_tty} #{pane_index}' |grep ^$T | cut -f2 -d' ')
        ALL=$(tmux lsp | wc -l)

        if [ $((ALL-I)) -le 1 ]
        then
            I=$(($I-1))
        fi
        tmux split-window -l 40% -h -t $((I+1))
    else
        $SHELL
    fi
  '';
in
{
  options.opt.yazi = {
    enable = mkEnableOption "yazi";
  };

  config = mkIf cfg.enable {
    home.packages =
      let
        external = with pkgs; [
          yazi
          unzip
          unrar
          p7zip
          sshfs
          curlftpfs
          archivemount
          trash-cli
          duckdb
          tmux-sp-s
          tmux-sp-v
        ];

      in
      external
      ++ [
        open
        xdg-open
      ];

    xdg = {
      configFile = {
        "yazi/yazi.toml".source = ./config/yazi.toml;
        "yazi/keymap.toml".source = ./config/keymaps.toml;
        # "yazi/theme.toml".source = ./config/theme.toml;
        "yazi/init.lua".source = ./config/init.lua;

        "yazi/plugins/archivemount.yazi".source = builtins.fetchGit {
          url = "https://github.com/AnirudhG07/archivemount.yazi";
          rev = "3d353c4d57198ae91a93c5f9d1c7345a5bcb7f84";
        };
        "yazi/plugins/yatline.yazi".source = builtins.fetchGit {
          url = "https://github.com/imsi32/yatline.yazi.git";
          rev = "88bd1c58357d472fe7e8daf9904936771fc49795";
        };
        "yazi/plugins/yatline-catppuccin.yazi".source = builtins.fetchGit {
          url = "https://github.com/imsi32/yatline-catppuccin.yazi.git";
          rev = "8cc4773ecab8ee8995485d53897e1c46991a7fea";
        };
        "yazi/plugins/duckdb.yazi".source = builtins.fetchGit {
          url = "https://github.com/wylie102/duckdb.yazi";
          rev = "3f8c8633d4b02d3099cddf9e892ca5469694ba22";
        };
        "yazi/plugins/compress.yazi".source = builtins.fetchGit {
          url = "https://github.com/KKV9/compress.yazi";
          rev = "c2646395394f22b6c40bff64dc4c8c922d210570";
        };
        "yazi/plugins/restore.yazi".source = builtins.fetchGit {
          url = "https://github.com/boydaihungst/restore.yazi";
          rev = "2161735f840e36974a6b4b0007c3e4184a085208";
        };
        "yazi/plugins/recycle-bin.yazi".source = builtins.fetchGit {
          url = "https://github.com/uhs-robert/recycle-bin.yazi";
          rev = "1762676a032e0de6d4712ae06d14973670621f61";
        };
        "yazi/plugins/full-border.yazi".source = "${yazi-rs-plugins}/full-border.yazi";
        "yazi/plugins/chmod.yazi".source = "${yazi-rs-plugins}/chmod.yazi";
        "yazi/plugins/mount.yazi".source = "${yazi-rs-plugins}/mount.yazi";
        "yazi/plugins/git.yazi".source = "${yazi-rs-plugins}/git.yazi";
        "yazi/plugins/zoom.yazi".source = "${yazi-rs-plugins}/zoom.yazi";
        # "yazi/flavors/catppuccin-macchiato.yazi".source = "${yazi-rs-flavors}/catppuccin-macchiato.yazi";
        # "yazi/flavors/catppuccin-latte.yazi".source = "${yazi-rs-flavors}/catppuccin-latte.yazi";

        "fish/functions/vifm.fish".text = ''
          function y
            set tmp (mktemp -t "yazi-cwd.XXXXXX")
            yazi $argv --cwd-file="$tmp"
            if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
              builtin cd -- "$cwd"
            end
            rm -f -- "$tmp"
          end
        '';
        "nushell/autoload/vifm.nu".text = ''
          def --env y [...args] {
            let tmp = (mktemp -t "yazi-cwd.XXXXXX")
            yazi ...$args --cwd-file $tmp
            let cwd = (open $tmp)
            if $cwd != "" and $cwd != $env.PWD {
              cd $cwd
            }
            rm -fp $tmp
          }
        '';
      };
    };
  };
}
