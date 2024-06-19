{ config, lib, pkgs, utils, ... }:
with lib;
let

  cfg = config.opt.nvim;
  dag = config.lib.dag;

  # jrnl = pkgs.writeShellScriptBin "jrnl" ''
  #   NOTE="$HOME/Notes/diary/$(date +%Y-%m-%d).md"
  #   if [ $# -ge 1 ]
  #   then
  #     echo "[$(date +%H:%M)] $*" >> "$NOTE"
  #     nvim -c '$' -c 'startinsert!' "$NOTE"
  #   else
  #     nvim -c '$' -c 'startinsert!' "$NOTE"
  #   fi
  # '';

  # todo = pkgs.writeShellScriptBin "todo" ''
  #   set -e
  #   NOTE="$HOME/Notes/diary/$(date +%Y-%m-%d).md"
  #   echo >> "$NOTE"
  #   echo "- [ ] TODO $*" >> "$NOTE"
  #   nvim -c '$' -c 'startinsert!' "$NOTE"
  # '';

  my-nvim = pkgs.symlinkJoin {
    name = "my-neovim";
    paths = [
      pkgs.neovim
    ];
    postBuild = ''
      ln -s $out/bin/nvim $out/bin/vim
      ln -s $out/bin/nvim $out/bin/vi
    '';
  };

  vim-compile = pkgs.writeShellScriptBin "vim-compile" ''
    ${my-nvim}/bin/nvim --headless --cmd 'lua _G.update=true'
  '';

  clean-cache = pkgs.writeShellScriptBin "nvim-clean-cache" ''
    set -e
    rm -rf ~/.cache/nvim
  '';

  vars = {
    conf.colors = cfg.colors;
    conf.theme = cfg.theme;
    conf.openai_token = cfg.openai_token;
    is_nix = "true";
    conf.orb = cfg.orb;
    conf.remote = cfg.remote;
  };
  # https://github.com/Exafunction/codeium/releases
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
    orb = mkOption { type = types.bool; default = false; };
    remote = mkOption { type = types.bool; default = false; };
  };

  config = mkIf cfg.enable {

    home.activation.nvim-changes = dag.entryAnywhere ''
      ${vim-compile}/bin/vim-compile
    '';

    home.packages = with pkgs; let
      androidPkgs = optionals cfg.android [ packs.codeium-lsp ];
      orbPkgs = optionals cfg.orb [ packs.codeium-lsp ];
    in
    [
      my-nvim
      vim-compile
      lazygit
      clean-cache
      ripgrep
      fd
      curl
      gzip

      python3

      # Langs
      gcc # required for treesitter
      # clang
      # go
      # gnumake
      # cargo
      # nodejs

      tree-sitter

      # LSP:
      clojure-lsp
      gopls
      # ltex-ls
      lua-language-server
      # nil
      nixd
      # nodePackages.bash-language-server
      pyright
      fennel-ls
      terraform-ls
      vscode-langservers-extracted
      yaml-language-server
      zk

      # Linter
      # ansible-lint
      clj-kondo
      # codespell
      # hadolint   # too massive on macos
      # markdownlint-cli
      # pylint
      # revive
      # staticcheck
      tflint
      tfsec
      # typos
      # yamllint

      # FMT
      black
      fnlfmt
      # gofmt
      # joker
      jq
      nixpkgs-fmt
      # nodePackages.sql-formatter
      nodePackages.prettier
      # python311Packages.autopep8
      shfmt
      # statix
      stylua
      # yamllint
      # yq
      zprint
      shellharden
      shfmt

      # Manual
      manix
    ] ++ androidPkgs ++ orbPkgs;
    xdg = {
      configFile = {

        "nvim/init.lua".source = ./config/nvim/init.lua;
        "nvim/init.fnl".source = utils.templateFile "init.fnl" ./config/nvim/init.fnl vars;

        "nvim/fnl".source = ./config/nvim/fnl;

        "nvim/lua/conf.lua".source = utils.templateFile "conf.lua" ./config/nvim/lua/conf.lua vars;
        "bash/profile.d/20_nvim_vars.sh".text = ''
          export EDITOR="vim"
          export VISUAL="vim"
          export GUI_EDITOR="vim"
        '';
      };
    };
  };
}
