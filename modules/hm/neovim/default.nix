{ config, lib, pkgs, utils, ... }:
let
  inherit (lib) mkOption types mkIf mkEnableOption optionals;
  inherit (pkgs) symlinkJoin writeShellScriptBin;

  cfg = config.opt.nvim;
  # dag = config.lib.dag;

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

  nvim = pkgs.writeShellScriptBin "nvim" ''
    set -e
    if [ "$#" -eq 0 ]; then
      ${pkgs.neovim}/bin/nvim "$@"
    else
      if [ -f "$1" ]; then
        if [ $(stat -c%s "$1") -gt 2097152 ]; then
          ${pkgs.neovim}/bin/nvim -u NONE "$@"
        else
          ${pkgs.neovim}/bin/nvim "$@"
        fi
      else
        ${pkgs.neovim}/bin/nvim "$@"
      fi
    fi
  '';

  my-nvim = symlinkJoin {
    name = "my-neovim";
    paths = [
      nvim
    ];
    postBuild = ''
      ln -s $out/bin/nvim $out/bin/vim
      ln -s $out/bin/nvim $out/bin/vi
      ln -s $out/bin/nvim $out/bin/v
    '';
  };

  # vim-compile = writeShellScriptBin "vim-compile" ''
  #   ${my-nvim}/bin/nvim --headless --cmd 'lua _G.update=true' || true
  # '';

  clean-cache = writeShellScriptBin "nvim-clean-cache" ''
    set -e
    rm -rf ~/.cache/nvim
  '';

  vars = {
    conf.colors = cfg.colors;
    conf.theme = cfg.theme;
    is_nix = "true";
    conf.orb = cfg.orb;
    conf.remote = cfg.remote;
  };
in
{
  options.opt.nvim = {
    enable = mkEnableOption "nvim";

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

    # home.activation.nvim-changes = dag.entryAnywhere ''
    #   ${vim-compile}/bin/vim-compile
    # '';

    home.packages =
      let
        androidPkgs = optionals cfg.android [ ];
        orbPkgs = optionals cfg.orb [ ];
        external = with pkgs; [
          luarocks
          nodejs

          lazygit
          ripgrep
          fd
          curl
          gzip
          par
          python3

          tree-sitter
          gcc # required for treesitter
          gnumake

          lua-language-server
          nil
          fennel-ls
          vscode-langservers-extracted
          yaml-language-server
          dockerfile-language-server

          fnlfmt
          jq
          nixpkgs-fmt
          nodePackages.prettier
          shfmt
          stylua
          shellharden
          shfmt

          kustomize
          kubeconform
          kubent

        ];
      in
      [
        my-nvim
        # vim-compile
        clean-cache
      ] ++ external ++ androidPkgs ++ orbPkgs;
    xdg = {
      configFile = {
        "nvim/init.lua".source = ./config/nvim/init.lua;
        "nvim/lua/conf.lua".source = utils.templateFile "conf.lua" ./config/nvim/lua/conf.lua vars;
        "nvim/lua/lib.lua".source = ./config/nvim/lua/lib.lua;
        "nvim/lua/base".source = ./config/nvim/lua/base;
        "nvim/lua/ft".source = ./config/nvim/lua/ft;
        "nvim/lua/plugins".source = ./config/nvim/lua/plugins;

        "bash/profile.d/20_nvim_vars.sh".text = ''
          export EDITOR="vim"
          export VISUAL="vim"
          export GUI_EDITOR="vim"
        '';
      };
    };
  };
}
