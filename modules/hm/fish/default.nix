{ config, lib, pkgs, utils, ... }:
let
  inherit (lib) mkEnableOption mkOption types;

  cfg = config.opt.fish;
  vars = {
    darwin = cfg.darwin;
    linux = !cfg.darwin;
    homeDirectory = cfg.homeDirectory;
    openAiToken = cfg.openai_token;
  };
in
{
  options.opt.fish = {
    enable = mkEnableOption "fish";
    darwin = mkOption {
      type = types.bool;
      default = false;
      description = "Enable fish on darwin";
    };
    openai_token = mkOption {
      type = types.str;
      default = "";
    };
    homeDirectory = mkOption {
      type = types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        fish
        carapace
        fzf
        zoxide
        eza
        bat
        fd
        global
        viddy
        gnutar
        zip
        # nushell
        # elvish
        exiftool
        tcpdump
        netcat
      ];
      file = {
        # ".profile".source = ./config/profile;
        ".bash_profile".source = ./config/profile;
        ".bashrc".source = utils.templateFile "bashrc" ./config/bashrc vars;
      };
    };
    xdg = {
      configFile = {
        # "elvish/rc.elv".text = ''
        #   for x [~/.config/elvish/*.d.elv] {
        #     eval (slurp < $x)
        #   }
        # '';
        #
        # "elvish/starship.d.elv".text = ''
        #   eval (starship init elvish)
        # '';
        #
        # "elvish/zoxide.d.elv".text = ''
        #   eval (zoxide init elvish | slurp)
        # '';
        #
        # "elvish/carapace.d.elv".text = ''
        #   set-env CARAPACE_BRIDGES 'fish,bash,inshellisense' # optional
        #   eval (carapace _carapace | slurp)
        # '';
        #
        # "elvish/aliases.d.elv".text = ''
        #   use epm
        #   epm:install github.com/zzamboni/elvish-modules
        #   use github.com/zzamboni/elvish-modules/alias
        #
        #   alias:new ww viddy
        #   # alias:save &verbose &all
        # '';

        "fish/conf.d/00_pre_init.fish".source = ./config/00_pre_init.fish;
        "fish/conf.d/01_init_interactive.fish".source = ./config/01_init_interactive.fish;
        "fish/conf.d/95_greeting.fish".source = ./config/95_greeting.fish;
        "fish/conf.d/99_zoxide.fish".source = ./config/99_zoxide.fish;
        "fish/conf.d/99_carapace.fish".source = ./config/99_carapace.fish;

        # disable brew completion
        "fish/conf.d/brew.fish".text = "";

        "fish/fish_plugins".source = ./config/fish_plugins;
        "fish/functions/fisher.fish".source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/jorgebucaran/fisher/HEAD/functions/fisher.fish";
          hash = "sha256-WWQNB72hgvKtD9/p3Ip5n7efRubl/EYDVP/i4h91log=";
        };

        "fish/conf.d/01_openai.fish".text = ''
          export OPENAI_API_KEY="${cfg.openai_token}"
        '';

        "bash/profile.d/01_path.sh".source = utils.templateFile "01_path.sh" ./config/01_path.sh vars;
        "bash/profile.d/02_lang.sh".source = ./config/02_lang.sh;
        "bash/profile.d/00_hostname.sh".text = ''
          if [ -z "$HOSTNAME" ] && command -v hostnamectl >/dev/null 2>&1; then
            export HOSTNAME=$(hostnamectl --transient 2>/dev/null)
          fi
          if [ -z "$HOSTNAME" ] && command -v hostname >/dev/null 2>&1; then
            export HOSTNAME=$(hostname 2>/dev/null)
          fi
          if [ -z "$HOSTNAME" ]; then
            export HOSTNAME=$(uname -n)
          fi
        '';

        # "nushell/env.nu".source = utils.templateFile "env.nu" ./config/env.nu vars;
        # "nushell/config.nu".source = utils.templateFile "config.nu" ./config/config.nu vars;
        # "nushell/granted.nu".source = ./config/granted.nu;
      };
    };
  };
}
