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

  yazi-rs = builtins.fetchGit {
    url = "https://github.com/yazi-rs/plugins";
    rev = "f9b3f8876eaa74d8b76e5b8356aca7e6a81c0fb7";
  };
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
        "yazi/init.lua".source = ./config/init.lua;
        "yazi/plugins/archivemount.yazi".source = builtins.fetchGit {
          url = "https://github.com/AnirudhG07/archivemount.yazi";
          rev = "3d353c4d57198ae91a93c5f9d1c7345a5bcb7f84";
        };
        "yazi/plugins/yatline.yazi".source = builtins.fetchGit {
          url = "https://github.com/imsi32/yatline.yazi.git";
          rev = "88bd1c58357d472fe7e8daf9904936771fc49795";
        };
        "yazi/plugins/full-border.yazi".source = "${yazi-rs}/full-border.yazi";
        "yazi/plugins/chmod.yazi".source = "${yazi-rs}/chmod.yazi";
        "yazi/plugins/mount.yazi".source = "${yazi-rs}/mount.yazi";

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
