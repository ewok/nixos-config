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
    rev = "86d28e4fb4f25f36cc501b8cb0badb37a6b14263";
  };

  yazi-rs-flavors = builtins.fetchGit {
    url = "https://github.com/yazi-rs/flavors";
    rev = "f6b425a6d57af39c10ddfd94790759f4d7612332";
  };

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
          mediainfo
        ];
        rich-wrapper = pkgs.writeShellScriptBin "rich-cli" ''
          export PYTHONWARNINGS="ignore:The parameter -j is used more than once:UserWarning:click.core:"
          ${pkgs.rich-cli}/bin/rich "$@"
        '';
      in
      external
      ++ [
        open
        xdg-open
        rich-wrapper
      ];

    xdg = {
      configFile = {

        # Yazi configuration files
        "yazi/yazi.toml".source = ./config/yazi.toml;
        "yazi/keymap.toml".source = ./config/keymaps.toml;
        "yazi/theme.toml".source = ./config/theme.toml;
        "yazi/init.lua".source = ./config/init.lua;

        # Plugins

        # File plugins
        "yazi/plugins/archivemount.yazi".source = builtins.fetchGit {
          url = "https://github.com/AnirudhG07/archivemount.yazi";
          rev = "3d353c4d57198ae91a93c5f9d1c7345a5bcb7f84";
        };
        "yazi/plugins/compress.yazi".source = builtins.fetchGit {
          url = "https://github.com/KKV9/compress.yazi";
          rev = "c2646395394f22b6c40bff64dc4c8c922d210570";
        };
        "yazi/plugins/mediainfo.yazi".source = builtins.fetchGit {
          url = "https://github.com/boydaihungst/mediainfo.yazi";
          rev = "1099409ca956282efe49dea8ab53f8be95feb72a";
        };
        "yazi/plugins/piper.yazi".source = "${yazi-rs-plugins}/piper.yazi";

        # UI plugins
        "yazi/plugins/full-border.yazi".source = "${yazi-rs-plugins}/full-border.yazi";
        "yazi/plugins/git.yazi".source = "${yazi-rs-plugins}/git.yazi";
        # "yazi/plugins/zoom.yazi".source = "${yazi-rs-plugins}/zoom.yazi";

        # Utility plugins
        "yazi/plugins/restore.yazi".source = builtins.fetchGit {
          url = "https://github.com/boydaihungst/restore.yazi";
          rev = "2161735f840e36974a6b4b0007c3e4184a085208";
        };
        "yazi/plugins/recycle-bin.yazi".source = builtins.fetchGit {
          url = "https://github.com/uhs-robert/recycle-bin.yazi";
          rev = "1762676a032e0de6d4712ae06d14973670621f61";
        };
        "yazi/plugins/chmod.yazi".source = "${yazi-rs-plugins}/chmod.yazi";
        "yazi/plugins/mount.yazi".source = "${yazi-rs-plugins}/mount.yazi";

        # Flavors - Tokyo Night (using default theme for now)
        # TODO: Create custom Tokyo Night flavor for Yazi
        # "yazi/flavors/catppuccin-macchiato.yazi".source = "${yazi-rs-flavors}/catppuccin-macchiato.yazi";
        # "yazi/flavors/catppuccin-latte.yazi".source = "${yazi-rs-flavors}/catppuccin-latte.yazi";

        # Integrations
        "fish/functions/y.fish".text = ''
          function y
            set tmp (mktemp -t "yazi-cwd.XXXXXX")
            yazi $argv --cwd-file="$tmp"
            if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
              builtin cd -- "$cwd"
            end
            rm -f -- "$tmp"
          end
        '';
        "nushell/autoload/yazi.nu".text = ''
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
