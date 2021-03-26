{ config, lib, pkgs, inputs, ... }:
with lib;
let
  dev = config.modules.dev;
  username = config.properties.user.name;

  jrnl = pkgs.writeScriptBin "jrnl" ''
    #!${pkgs.bash}/bin/bash
    NOTE="$HOME/Notes/diary/$(date +%Y-%m-%d).md"
    if [ $# -ge 1 ]
    then
    echo "[$(date +%H:%M)] $*" >> "$NOTE"
    vim "$NOTE"
    else
    vim +VimwikiMakeDiaryNote
    fi
  '';

  my-nvim = pkgs.symlinkJoin {
    name = "my-neovim";
    paths = [ pkgs.neovim-nightly ];
    postBuild = ''
    ln -s $out/bin/nvim $out/bin/vim
    ln -s $out/bin/nvim $out/bin/vi
    '';
    };

  master = import inputs.master ({
    config = config.nixpkgs.config;
    localSystem = { system = "x86_64-linux"; };
  });

in
  {
    config = mkIf dev.enable {

      home-manager.users."${username}" = {

        home.packages = with pkgs; [
          master.tree-sitter
          my-nvim
          global
          # Does not work again
          # hadolint
          gcc
          shellcheck
          silver-searcher
          vale
          yamllint
          par
          nodejs
          nodePackages.markdown-link-check
          nodePackages.livedown
          # All in python.nix
          # python3Packages.pynvim
          # python3Packages.msgpack
          # python3Packages.jedi
          # python3Packages.debugpy
          # language servers
          rust-analyzer
          terraform-lsp
          sumneko-lua-language-server
          nodePackages.bash-language-server
          nodePackages.pyright
          nodePackages.dockerfile-language-server-nodejs
          nodePackages.vscode-json-languageserver
          # nodePackages.sql-language-server
          nodePackages.yaml-language-server
        ] ++ [
          jrnl
        ];

        xdg.configFile."nvim/init.lua".source = ./config/init.lua;
        xdg.configFile."nvim/.gitignore".source = ./config/gitignore;
        # home.file.".vim/vimrc".source = ./config/init.vim;
        home.file.".ctags".source = ./config/ctags;
        home.file.".vale.ini".source = ./config/vale.ini;
        home.sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
          GUI_EDITOR = "/usr/bin/nvim";
        };
      };
    };
  }
