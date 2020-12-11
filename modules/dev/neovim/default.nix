{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.modules.dev;
  username = config.properties.user.name;
in
{
  config = mkIf dev.enable {

    home-manager.users."${username}" = {

      programs.neovim = {
        enable = true;
        package =  pkgs.neovim-nightly;
        viAlias = true;
        vimAlias = true;
      };

      home.packages = with pkgs; [
        global
        hadolint
        shellcheck
        silver-searcher
        terraform-lsp
        vale
        yamllint
        par
        nodejs
        nodePackages.markdown-link-check
        nodePackages.bash-language-server
        nodePackages.livedown
        python3Packages.pynvim
        python3Packages.msgpack
      ];

      xdg.configFile."nvim/init.vim".source = ./config/init.vim;
      xdg.configFile."nvim/.gitignore".source = ./config/gitignore;
      home.file.".vim/vimrc".source = ./config/init.vim;
      home.file.".vim/.gitignore".source = ./config/gitignore;
      home.file.".ctags".source = ./config/ctags;
      home.file.".vale.ini".source = ./config/vale.ini;
      home.file.".ideavimrc".source = ./config/ideavimrc;
      home.file."bin/jrnl" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          NOTE="$HOME/Notes/diary/$(date +%Y-%m-%d).md"
          if [ $# -ge 1 ]
          then
          echo "[$(date +%H:%M)] $*" >> "$NOTE"
          vim "$NOTE"
          else
          vim +VimwikiMakeDiaryNote
          fi
        '';
      };
      home.sessionVariables.EDITOR = "nvim";
    };
  };
}
