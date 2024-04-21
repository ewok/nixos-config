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
    rm -rf ~/.cache/nvim
  '';

  vars = {
    conf.colors = cfg.colors;
    conf.theme = cfg.theme;
    conf.openai_token = cfg.openai_token;
    is_nix = "true";
  };

  version = "1.8.25";
  ls-system = "linux_arm";
  hash = "sha256-Gt48FrW9MF4xppmA4TsuEe3iJYn8DrKhtFmb8N7rO+s=";
  packs = with pkgs; {
    codeium-lsp = stdenv.mkDerivation
      {
        pname = "codeium-lsp";
        version = "v${version}";

        src = pkgs.fetchurl {
          url = "https://github.com/Exafunction/codeium/releases/download/language-server-v${version}/language_server_${ls-system}";
          sha256 = hash;
        };

        sourceRoot = ".";

        phases = [ "installPhase" "fixupPhase" ];
        nativeBuildInputs =
          [
            stdenv.cc.cc
          ]
          ++ (
            if !stdenv.isDarwin
            then [ autoPatchelfHook ]
            else [ ]
          );

        installPhase = ''
          mkdir -p $out/bin
          install -m755 $src $out/bin/codeium-lsp
        '';
      };
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
    android = mkOption { type = types.bool; default = false; };
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; let
      androidPkgs = optionals cfg.android [ packs.codeium-lsp ];
    in
    [
      my-nvim
      lazygit
      clean-cache
      ripgrep
      fd
      curl
      gzip

      python3

      # Langs
      # gcc
      clang
      go

      # LSP:
      # clojure-lsp
      # gopls
      # ltex-ls
      # lua-language-server
      # nodePackages.bash-language-server
      # nodePackages.pyright
      nil
      # terraform-ls
      # vscode-langservers-extracted
      # yaml-language-server
      # zk

      # Linter
      # clj-kondo
      # hadolint   # too massive on macos
      # markdownlint-cli
      # tflint
      # tfsec
      # revive
      # staticcheck
      # codespell
      # typos

      # FMT
      # joker
      # fnlfmt
      # python311Packages.autopep8
      # black
      # stylua
      nixpkgs-fmt
      # statix
      # shfmt
      # jq
      # yq
      # yamllint
      # prettier
      # nodePackages.sql-formatter
      # gofmt
    ] ++ androidPkgs;
    xdg = {
      configFile = {

        "nvim/init.lua".source = ./config/nvim/init.lua;
        # "nvim/fnl/ft".source = ./config/neovim/fnl/ft;
        # "nvim/fnl/plugins".source = ./config/neovim/fnl/plugins;
        # "nvim/fnl/after.fnl".source = ./config/neovim/fnl/after.fnl;
        # "nvim/fnl/before.fnl".source = ./config/neovim/fnl/before.fnl;
        # "nvim/fnl/init.fnl".source = ./config/neovim/fnl/init.fnl;
        # "nvim/fnl/keybinds.fnl".source = ./config/neovim/fnl/keybinds.fnl;
        # "nvim/fnl/lib.fnl".source = ./config/neovim/fnl/lib.fnl;
        # "nvim/fnl/settings.fnl".source = ./config/neovim/fnl/settings.fnl;

        # "nvim/fnl/constants.fnl".source = utils.templateFile "constants.fnl" ./config/neovim/fnl/constants.fnl vars;
        # Bug
        # "fnlm/fnl".source = ./config/neovim/fnl;

        "nvim/lua/configs".source = ./config/nvim/lua/configs;
        "nvim/lua/plugins".source = ./config/nvim/lua/plugins;
        "nvim/lua/ft".source = ./config/nvim/lua/ft;
        "nvim/lua/conf.lua".source = utils.templateFile "conf.lua" ./config/nvim/lua/conf.lua vars;
        "nvim/lua/lib.lua".source = ./config/nvim/lua/lib.lua;
        "nvim/lua/mappings.lua".source = ./config/nvim/lua/mappings.lua;
        "nvim/lua/post.lua".source = ./config/nvim/lua/post.lua;
        "nvim/lua/pre.lua".source = ./config/nvim/lua/pre.lua;
        "nvim/lua/settings.lua".source = ./config/nvim/lua/settings.lua;

        "fish/conf.d/20_nvim_vars.fish".text = ''
          if ! test -z "$NVIM"
              fish_add_path --path -p ~/.local/share/nvim/mason/bin
          end
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
