{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.nvim;
  colors = cfg.colors;

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

  # master = import inputs.master (
  #   {
  #     config = config.nixpkgs.config;
  #     localSystem = { system = "x86_64-linux"; };
  #   }
  # );

  # rnix = import inputs.rnix ({
  #   config = config.nixpkgs.config;
  #   localSystem = { system = "x86_64-linux"; };
  # });

in
{
  options.opt.nvim = {
    enable = mkOption { type = types.bool; };
    gui = mkOption { type = types.bool; };
    username = mkOption {type = types.str;};
    colors = {
        background = mkOption {
          type = types.str;
        };
        foreground = mkOption {
          type = types.str;
        };
        text = mkOption {
          type = types.str;
        };
        cursor = mkOption {
          type = types.str;
        };
        # Black
        color0 = mkOption {
          type = types.str;
        };
        # Red
        color1 = mkOption {
          type = types.str;
        };
        # Green
        color2 = mkOption {
          type = types.str;
        };
        # Yellow
        color3 = mkOption {
          type = types.str;
        };
        # Blue
        color4 = mkOption {
          type = types.str;
        };
        # Magenta
        color5 = mkOption {
          type = types.str;
        };
        # Cyan
        color6 = mkOption {
          type = types.str;
        };
        # White
        color7 = mkOption {
          type = types.str;
        };
        # Br Black
        color8 = mkOption {
          type = types.str;
        };
        # Br Red
        color9 = mkOption {
          type = types.str;
        };
        # Br Green
        color10 = mkOption {
          type = types.str;
        };
        # Br Yellow
        color11 = mkOption {
          type = types.str;
        };
        # Br Blue
        color12 = mkOption {
          type = types.str;
        };
        # Br Magenta
        color13 = mkOption {
          type = types.str;
        };
        # Br Cyan
        color14 = mkOption {
          type = types.str;
        };
        # Br White
        color15 = mkOption {
          type = types.str;
        };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${cfg.username} = {
      home.packages = with pkgs; [

        global
        jrnl
        my-nvim
        python3Packages.pynvim
        ripgrep
        rnix-lsp
        silver-searcher
        todo
        tree-sitter
        yaml-language-server
        zk

      ] ++ optionals (cfg.gui) [
        pkgs.libnotify
      ];

      # # Orgmode notifications
      # systemd.user.services.orgmode-notify = {
      #   Unit = { Description = "notify orgmode"; };
      #   Service = {
      #     Type = "simple";
      #     Environment = ''DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus PATH="/home/${username}/.nix-profile/bin:/run/current-system/sw/bin"'';
      #     ExecStart = ''${my-nvim}/bin/nvim -u NONE --noplugin --headless -c "lua require('orgmode').cron(require('partials.notify_org'))"'';
      #   };
      # };
      # systemd.user.timers.orgmode-notify = {
      #   Unit = { Description = "notify orgmode"; };
      #   Timer = {
      #     Unit = "orgmode-notify.service";
      #     OnCalendar = "minutely";
      #     Persistent = true;
      #   };
      #   Install = { WantedBy = [ "timers.target" ]; };
      # };

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
      ] (readFile ./config/neovim/init.lua);

      # xdg.configFile."nvim/lua/partials/notify_org.lua".text = ''
      #   return {
      #       org_agenda_files = {'~/Notes/org/*'},
      #       org_default_notes_file = '~/Notes/org/inbox.org',
      #       notifications = {
      #         reminder_time = {0, 5, 10},
      #         repeater_reminder_time = true,
      #     },
      #   }
      # '';

      xdg.configFile."nvim/.gitignore".source = ./config/neovim/gitignore;
      home.file.".ctags".source = ./config/neovim/ctags;
      home.file.".vale.ini".source = ./config/neovim/vale.ini;
      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        GUI_EDITOR = "${my-nvim}/bin/nvim";
      };
    };
  };
}
