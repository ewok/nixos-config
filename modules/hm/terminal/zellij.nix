{ config, lib, pkgs, utils, ... }:
let
  inherit (lib) mkIf optionals;

  cfg = config.opt.terminal;

  vars = {
    conf.colors = cfg.colors;
    conf.theme.common = cfg.theme.common;
    conf.terminal = cfg.zellij.terminal;
    conf.orb = cfg.orb;
    conf.homeDir = cfg.homeDirectory;
  };

  zj = pkgs.writeShellScriptBin "zj" ''
    #!${pkgs.bash}/bin/bash

    if [ "$ZELLIJ" != "" ]; then
      echo "In zellij already. Exiting..."
      exit 1;
    fi

    LOCK_FILE="$HOME/.local/state/zj.lock"
    mkdir -p "$(dirname "$LOCK_FILE")"

    cleanup_lock() {
      if [[ -f "$LOCK_FILE" ]]; then
        LOCK_PID=$(cat "$LOCK_FILE" 2>/dev/null)
        if [[ "$LOCK_PID" == "$$" ]]; then
          rm -f "$LOCK_FILE"
        fi
      fi
    }
    trap cleanup_lock EXIT INT TERM

    echo "$$" > "$LOCK_FILE"

    # No session name provided - loop until sessions are present or exited with error
    while true; do

      SESSIONS=$(${pkgs.zellij}/bin/zellij list-sessions 2>/dev/null | ${pkgs.gnugrep}/bin/grep -v "EXITED" | ${pkgs.gnugrep}/bin/grep -v "current" | ${pkgs.gnused}/bin/sed 's/\x1b\[[0-9;]*m//g' | ${pkgs.gawk}/bin/awk '{print $1}')

      FOUND_SESSION=""
      for sess in $SESSIONS; do
        client_count=$(${pkgs.zellij}/bin/zellij --session "$sess" action list-clients 2>/dev/null | ${pkgs.coreutils}/bin/wc -l)
        # If only header line (1 line), no clients connected
        if [ "$client_count" -le 1 ]; then
          FOUND_SESSION="$sess"
          break
        fi
      done

      if [[ -n "$FOUND_SESSION" ]]; then
        echo "Attaching to unattached session: $FOUND_SESSION"
        ${pkgs.zellij}/bin/zellij attach "$FOUND_SESSION"
        EXIT_CODE=$?
      else
        echo "Creating new session: main"
        ${pkgs.zellij}/bin/zellij "$@"
        EXIT_CODE=$?
      fi

      sleep 0.3 # Zellich is realy quick detaching a session

      if [[ ! -f "$LOCK_FILE" ]]; then
        echo "Lock file missing, exiting..."
        exit 1
      fi

      # If zellij exited with error, break loop and exit
      if [ $EXIT_CODE -ne 0 ]; then
        exit $EXIT_CODE
      fi
    done
  '';

  bashPassKeys = pkgs.symlinkJoin {
    name = "bash_pass_keys";
    paths = [ pkgs.bash ];
    postBuild = ''
      ln -s $out/bin/bash $out/bin/bash_pass_keys
    '';
  };

in
{
  config = mkIf (cfg.enable && cfg.zellij.enable)
    {
      home.packages =
        let
          optionalPkgs = optionals cfg.zellij.install [ pkgs.zellij ];
          external = with pkgs; [
            zoxide
            fzf
            gnugrep
            gnused
            gawk
            coreutils
            procps
            bc
          ];
        in
        [
          zj
          bashPassKeys
        ] ++ external ++ optionalPkgs;
      xdg.configFile."zellij/config.kdl".source = utils.templateFile "zellij.kdl" ./config/zellij.kdl vars;
      xdg.configFile."zellij/layouts/my.kdl".source = utils.templateFile "my.kdl" ./config/my.kdl vars;
      # Monitoring scripts
      xdg.configFile."zellij/scripts/zellij_cpu" = {
        source = utils.templateFile "zellij_cpu" ./config/zellij_cpu vars;
        executable = true;
      };
      xdg.configFile."zellij/scripts/zellij_ram" = {
        source = utils.templateFile "zellij_ram" ./config/zellij_ram vars;
        executable = true;
      };
      xdg.configFile."zellij/scripts/zellij_network" = {
        source = utils.templateFile "zellij_network" ./config/zellij_network vars;
        executable = true;
      };
      xdg.configFile."zellij/scripts/zellij_battery" = {
        source = utils.templateFile "zellij_battery" ./config/zellij_battery vars;
        executable = true;
      };
      xdg.configFile."zellij/scripts/zellij_blocks" = {
        source = utils.templateFile "zellij_blocks" ./config/zellij_blocks vars;
        executable = true;
      };
      xdg.configFile."zellij/scripts/zesh" = {
        source = utils.templateFile "zesh" ./config/zesh.sh vars;
        executable = true;
      };
      xdg.configFile."zellij/scripts/zellij_toggle" = {
        source = utils.templateFile "zellij_toggle" ./config/zellij_toggle vars;
        executable = true;
      };
      # https://github.com/sharph/zellij-nvim-nav-plugin/releases/download/v1.0.0/zellij-nvim-nav-plugin.wasm
      # get from github
      xdg.configFile."zellij/plugins/zellij-nvim-nav-plugin.wasm".source = pkgs.fetchurl {
        url = "https://github.com/sharph/zellij-nvim-nav-plugin/releases/download/v1.0.0/zellij-nvim-nav-plugin.wasm";
        sha256 = "sha256-W2HJuGr0t6B08NMfz5O+bm5lmNekelyV3j9kvv2swQM=";
      };
      # https://github.com/dj95/zjstatus/releases/download/v0.22.0/zjstatus.wasm
      xdg.configFile."zellij/plugins/zjstatus.wasm".source = pkgs.fetchurl {
        url = "https://github.com/dj95/zjstatus/releases/download/v0.22.0/zjstatus.wasm";
        sha256 = "sha256-TeQm0gscv4YScuknrutbSdksF/Diu50XP4W/fwFU3VM=";
      };
      # https://github.com/mostafaqanbaryan/zellij-switch/releases/download/0.2.1/zellij-switch.wasm
      xdg.configFile."zellij/plugins/zellij-switch.wasm".source = pkgs.fetchurl {
        url = "https://github.com/mostafaqanbaryan/zellij-switch/releases/download/0.2.1/zellij-switch.wasm";
        sha256 = "sha256-7yV+Qf/rczN+0d6tMJlC0UZj0S2PWBcPDNq1BFsKIq4=";
      };
    };
}
