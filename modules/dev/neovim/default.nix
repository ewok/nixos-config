{ config, lib, pkgs, inputs, ... }:
with lib;
let
  dev = config.modules.dev;
  colors = config.properties.theme.colors;
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

  master = import inputs.master (
    {
      config = config.nixpkgs.config;
      localSystem = { system = "x86_64-linux"; };
    }
  );

  # rnix = import inputs.rnix ({
  #   config = config.nixpkgs.config;
  #   localSystem = { system = "x86_64-linux"; };
  # });

in
{
  config = mkIf dev.enable {

    home-manager.users."${username}" = {

      home.packages = with pkgs; [
        universal-ctags
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
        # All in python.nix
        # python3Packages.pynvim
        # python3Packages.msgpack
        # python3Packages.jedi
        # python3Packages.debugpy
        rust-analyzer

        terraform-ls
        tflint

        sumneko-lua-language-server
        nodePackages.bash-language-server
        nodePackages.dockerfile-language-server-nodejs
        nodePackages.livedown
        nodePackages.markdown-link-check
        nodePackages.pyright
        # nodePackages.sql-language-server
        nodePackages.vscode-json-languageserver
        nodePackages.yaml-language-server
        rnix-lsp
        gopls
      ] ++ [
        jrnl
      ];

      xdg.configFile."nvim/init.lua".text = replaceStrings [
        ''color_0 = "#282c34"''
        ''color_1 = "#e06c75",''
        ''color_2 = "#98c379",''
        ''color_3 = "#e5c07b",''
        ''color_4 = "#61afef",''
        ''color_5 = "#c678dd",''
        ''color_6 = "#56b6c2",''
        ''color_7 = "#abb2bf",''
        ''color_8 = "#545862",''
        ''color_9 = "#d19a66",''
        ''color_10 = "#353b45",''
        ''color_11 = "#3e4451",''
        ''color_12 = "#565c64",''
        ''color_13 = "#b6bdca",''
        ''color_14 = "#be5046",''
        ''color_15 = "#c8ccd4",''
          ] [
        ''color_0 = "#${colors.color0}"''
        ''color_1 = "#${colors.color1}",''
        ''color_2 = "#${colors.color2}",''
        ''color_3 = "#${colors.color3}",''
        ''color_4 = "#${colors.color4}",''
        ''color_5 = "#${colors.color5}",''
        ''color_6 = "#${colors.color6}",''
        ''color_7 = "#${colors.color7}",''
        ''color_8 = "#${colors.color8}",''
        ''color_9 = "#${colors.color9}",''
        ''color_10 = "#${colors.color10}",''
        ''color_11 = "#${colors.color11}",''
        ''color_12 = "#${colors.color12}",''
        ''color_13 = "#${colors.color13}",''
        ''color_14 = "#${colors.color14}",''
        ''color_15 = "#${colors.color15}",''
      ] (readFile ./config/init.lua);
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
