{ config, lib, pkgs, utils, ... }:
let
  inherit (lib) mkEnableOption mkOption types;

  cfg = config.opt.shell;
  vars = {
    darwin = cfg.darwin;
    linux = !cfg.darwin;
    homeDirectory = cfg.homeDirectory;
    shell = cfg.shell;
  };

in
{
  options.opt.shell = {
    enable = mkEnableOption "fish";
    shell = mkOption {
      type = types.str;
      default = "fish"; # fish, nushell
      description = "The shell to use";
    };
    darwin = mkOption {
      type = types.bool;
      default = false;
      description = "Enable fish on darwin";
    };
    homeDirectory = mkOption {
      type = types.str;
    };
  };

  imports = [ ./fish.nix ./nushell.nix ];

  config = lib.mkIf cfg.enable {

    home = {
      packages = with pkgs; [
        carapace
        fzf
        zoxide
        eza
        bat
        fd
        # global
        viddy
        gnutar
        zip
        exiftool
        tcpdump
        netcat
        ttyd

      ];
      file = {
        ".bash_profile".source = ./config/profile;
        ".bashrc".source = utils.templateFile "bashrc" ./config/bashrc vars;
      };
    };

    xdg = {
      configFile = {
        "bash/rc.d/01_path.sh".source = utils.templateFile "01_path.sh" ./config/01_path.sh vars;
        "bash/rc.d/02_lang.sh".source = ./config/02_lang.sh;
        "bash/rc.d/00_hostname.sh".text = ''
          if [ -z "$HOSTNAME" ] && command -v hostnamectl >/dev/null 2>&1; then
            export HOSTNAME=$(hostnamectl --transient 2>/dev/null)
          fi
          if [ -z "$HOSTNAME" ] && command -v hostname >/dev/null 2>&1; then
            export HOSTNAME=$(hostname 2>/dev/null)
          fi
          if [ -z "$HOSTNAME" ]; then
            export HOSTNAME=$(uname -n)
          fi
          export DO_NOT_TRACK=1
        '';
      };
    };
  };
}
