{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf readFile mkOption types;

  cfg = config.opt.vifm;

  # Theme mapping function
  getThemeFile = theme:
    if theme == "onedark" then ./config/vifm/colors/onedark_base16.vifm
    else if theme == "catppuccin-macchiato" then ./config/vifm/colors/catppuccin_macchiato.vifm
    else if theme == "catppuccin-mocha" then ./config/vifm/colors/catppuccin_mocha.vifm
    else if theme == "tokyonight" then ./config/vifm/colors/tokyo_base16.vifm
    else ./config/vifm/colors/onedark_base16.vifm; # fallback to default

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
in
{
  options.opt.vifm = {
    enable = mkEnableOption "vifm";
    theme = mkOption {
      type = types.str;
      description = "ViFM theme. Available: onedark, catppuccin-macchiato, catppuccin-mocha, tokyonight";
      default = "onedark";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      let
        external = with pkgs; [
          vifm
          unzip
          unrar
          p7zip
          sshfs
          curlftpfs
          ts
          archivemount
          # dpkg
          viu
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
        "vifm/vifmrc".text = ''
          ${readFile ./config/vifm/vifmrc}
          ${readFile (getThemeFile cfg.theme)}
          ${readFile ./config/vifm/plugins/devicons.vifm}
          ${readFile ./config/vifm/vifm_commands}
          ${readFile ./config/vifm/vifm_keys}
          ${readFile ./config/vifm/vifm_ext}
          ${readFile ./config/vifm/vifm_custom}
        '';

        "vifm/scripts".source = ./config/vifm/scripts;

        "fish/functions/f.fish".text = ''
          function f
              set -l dst (command vifm --choose-dir - $argv)
              if test -z "$dst"
                  echo 'Directory picking cancelled/failed'
                  return 1
              end

              cd "$dst"
          end
        '';
        "nushell/autoload/vifm.nu".text = ''
          def --env f [...all] {
              let dst = (run-external "vifm" "--choose-dir" "-" ...$all)
              if ($dst == "") {
                  echo "Directory picking cancelled/failed"
                  return 1
              }
              cd $dst
          }
        '';
      };
    };
  };
}
