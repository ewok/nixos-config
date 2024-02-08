{ config, lib, pkgs, utils, ... }:
with lib;
let
  cfg = config.opt.nvim;

  jrnl = pkgs.writeShellScriptBin "jrnl" ''
    NOTE="$HOME/Notes/diary/$(date +%Y-%m-%d).md"
    if [ $# -ge 1 ]
    then
      echo "[$(date +%H:%M)] $*" >> "$NOTE"
      nvim -c '$' -c 'startinsert!' "$NOTE"
    else
      nvim -c '$' -c 'startinsert!' "$NOTE"
    fi
  '';

  todo = pkgs.writeShellScriptBin "todo" ''
    set -e
    NOTE="$HOME/Notes/diary/$(date +%Y-%m-%d).md"
    echo >> "$NOTE"
    echo "- [ ] TODO $*" >> "$NOTE"
    nvim -c '$' -c 'startinsert!' "$NOTE"
  '';


  my-nvim = pkgs.symlinkJoin {
    name = "my-neovim";
    paths = [ pkgs.neovim ];
    postBuild = ''
      ln -s $out/bin/nvim $out/bin/vim
      ln -s $out/bin/nvim $out/bin/vi
    '';
  };

  clean-cache = pkgs.writeShellScriptBin "nvim-clean-cache" ''
    set -e
    rm -rf ~/.cache/nvim/hotpot/
    rm -rf ~/.cache/nvim/lazy/
  '';

  vars = {
    conf.colors = cfg.colors;
    conf.theme = cfg.theme;
    conf.openai_token = cfg.openai_token;
  };

in
{
  options.opt.nvim = {
    enable = mkEnableOption "nvim";
    openai_token = mkOption {
      type = types.str;
    };

    theme = mkOption {
      type = types.attrsOf types.str;
      default = {
        name = "onedark";
        separator_left = "";
        separator_right = "";
        alt_separator_left = "";
        alt_separator_right = "";
      };
    };

    colors = mkOption {
      type = types.attrsOf types.str;
      default = {
        base00 = "282c34";
        base01 = "353b45";
        base02 = "3e4451";
        base03 = "545862";
        base04 = "565c64";
        base05 = "abb2bf";
        base06 = "b6bdca";
        base07 = "c8ccd4";
        base08 = "e06c75";
        base09 = "d19a66";
        base0A = "e5c07b";
        base0B = "98c379";
        base0C = "56b6c2";
        base0D = "61afef";
        base0E = "c678dd";
        base0F = "be5047";
      };
    };

  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      my-nvim
      lazygit
      clean-cache
      ripgrep
      fd
      curl
      gzip

      python3

      # Langs
      gcc

      # LSP:
      clojure-lsp
      gopls
      ltex-ls
      lua-language-server
      nodePackages.bash-language-server
      nodePackages.pyright
      nil
      terraform-ls
      vscode-langservers-extracted
      yaml-language-server
      zk

      # Linter
      clj-kondo
      # hadolint   # too massive on macos
      markdownlint-cli
      tflint
      tfsec
      # revive
      # staticcheck
      # codespell
      # typos

      # FMT
      joker
      fnlfmt
      python311Packages.autopep8
      black
      stylua
      nixpkgs-fmt
      statix
      shfmt
      jq
      yq
      # prettier
      # nodePackages.sql-formatter
      # gofmt
    ];

    xdg = {
      configFile = {

        "nvim/init.lua".source = ./config/neovim/init.lua;
        "nvim/fnl/ft".source = ./config/neovim/fnl/ft;
        "nvim/fnl/plugins".source = ./config/neovim/fnl/plugins;
        "nvim/fnl/after.fnl".source = ./config/neovim/fnl/after.fnl;
        "nvim/fnl/before.fnl".source = ./config/neovim/fnl/before.fnl;
        "nvim/fnl/init.fnl".source = ./config/neovim/fnl/init.fnl;
        "nvim/fnl/keybinds.fnl".source = ./config/neovim/fnl/keybinds.fnl;
        "nvim/fnl/lib.fnl".source = ./config/neovim/fnl/lib.fnl;
        "nvim/fnl/settings.fnl".source = ./config/neovim/fnl/settings.fnl;

        "nvim/fnl/constants.fnl".source = utils.templateFile "constants.fnl" ./config/neovim/fnl/constants.fnl vars;
        # Bug
        "fnlm/fnl".source = ./config/neovim/fnl;

        "fish/conf.d/20_nvim_vars.fish".text = ''
          # if ! test -z "$NVIM"
          #     fish_add_path --path -p ~/.local/share/nvim/mason/bin
          # end
        '';
        "bash/profile.d/20_nvim_vars.sh".text = ''
          export EDITOR="vim"
          export VISUAL="vim"
          export GUI_EDITOR="vim"
        '';
      };
    };
  };
}
