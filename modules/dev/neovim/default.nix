{ config, lib, pkgs, inputs, ... }:
with lib;
let
  dev = config.modules.dev;
  gui = config.modules.gui;
  colors = config.properties.theme.colors;
  username = config.properties.user.name;

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

  master = import inputs.master ({
    config = config.nixpkgs.config;
    localSystem = { system = "x86_64-linux"; };
  });

  # rnix = import inputs.rnix ({
  #   config = config.nixpkgs.config;
  #   localSystem = { system = "x86_64-linux"; };
  # });

in
{
  config = mkIf dev.enable {

    home-manager.users."${username}" = {

      home.packages = with pkgs; [

        my-nvim

        universal-ctags
        tree-sitter
        global

        gcc
        par
        silver-searcher

        # Linters
        hadolint
        languagetool
        luaPackages.luacheck
        shellcheck
        tflint
        vale
        yamllint

        # All in python.nix
        # python3Packages.pynvim
        # python3Packages.msgpack
        # python3Packages.jedi
        # python3Packages.debugpy
        rust-analyzer

        # LSP
        master.terraform-ls
        sumneko-lua-language-server
        nodejs
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

        jrnl
        todo

      ] ++ optionals (gui.enable) [
        pkgs.libnotify
      ];

      # Sync notes service
      systemd.user.services.notes-sync = {
        Unit = { Description = "Sync notes"; };
        Service = {
          CPUSchedulingPolicy = "idle";
          IOSchedulingClass = "idle";
          Environment = "SSH_AUTH_SOCK=/run/user/1000/gnupg/S.gpg-agent.ssh";
          ExecStart = toString (
            pkgs.writeShellScript "notes-sync" ''
              set -e
              ${pkgs.busybox}/bin/nc -z github.com 22
              DATE=$(${pkgs.coreutils}/bin/date)
              ${pkgs.git}/bin/git -C ~/Notes pull
              ${pkgs.git}/bin/git -C ~/Notes add .
              ${pkgs.git}/bin/git -C ~/Notes commit -m "Auto commit + push. $DATE" || exit 0
              ${pkgs.git}/bin/git -C ~/Notes push
            ''
          );
        };
      };
      systemd.user.timers.notes-sync = {
        Unit = { Description = "Sync notes"; };
        Timer = {
          Unit = "notes-sync.service";
          OnCalendar = "hourly";
          Persistent = true;
        };
        Install = { WantedBy = [ "timers.target" ]; };
      };

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
      ] (readFile ./config/init.lua);
      xdg.configFile."nvim/lua/partials/notify_org.lua".text = ''
        return {
            org_agenda_files = {'~/Notes/org/*'},
            org_default_notes_file = '~/Notes/org/inbox.org',
            notifications = {
              reminder_time = {0, 5, 10},
              repeater_reminder_time = true,
          },
        }
      '';
      xdg.configFile."nvim/.gitignore".source = ./config/gitignore;
      home.file.".ctags".source = ./config/ctags;
      home.file.".vale.ini".source = ./config/vale.ini;
      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        GUI_EDITOR = "${my-nvim}/bin/nvim";
      };
    };
  };
}
