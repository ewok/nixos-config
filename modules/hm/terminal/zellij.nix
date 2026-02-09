# Zellij configuration module
#
# The zesh script (config/zesh.sh) provides fzf-based session management.
# It has two modes:
#   1. If `zesh` binary is available (https://github.com/roberte777/zesh),
#      it uses the Rust implementation which can properly switch sessions from within zellij
#   2. Otherwise, it falls back to a bash implementation that shows instructions for manual switching
#
# To install zesh:
#   cargo install --locked zesh
# Or add it to your home.packages if/when it's available in nixpkgs

{ config, lib, pkgs, utils, ... }:
let
  inherit (lib) mkIf optionals mapAttrs;

  cfg = config.opt.terminal;

  hexDigitValue = char:
    let
      upper = lib.strings.toUpper char;
    in
    if upper == "0" then 0 else
    if upper == "1" then 1 else
    if upper == "2" then 2 else
    if upper == "3" then 3 else
    if upper == "4" then 4 else
    if upper == "5" then 5 else
    if upper == "6" then 6 else
    if upper == "7" then 7 else
    if upper == "8" then 8 else
    if upper == "9" then 9 else
    if upper == "A" then 10 else
    if upper == "B" then 11 else
    if upper == "C" then 12 else
    if upper == "D" then 13 else
    if upper == "E" then 14 else
    if upper == "F" then 15 else
    builtins.throw "invalid hex digit: ${char}";

  hexPairToInt = pair:
    (hexDigitValue (builtins.substring 0 1 pair)) * 16
    + hexDigitValue (builtins.substring 1 1 pair);

  hexToRgb = hex:
    let
      normalized = lib.strings.removePrefix "#" hex;
    in
    {
      r = hexPairToInt (builtins.substring 0 2 normalized);
      g = hexPairToInt (builtins.substring 2 2 normalized);
      b = hexPairToInt (builtins.substring 4 2 normalized);
    };

  colorsRGB = mapAttrs (_: hexToRgb) cfg.colors;

  vars = {
    conf.colors = cfg.colors;
    conf.colorsRGB = colorsRGB;
    conf.theme.common = cfg.theme.common;
    conf.terminal = cfg.zellij.terminal;
    conf.orb = cfg.orb;
    conf.homeDir = cfg.homeDirectory;
  };

  zj = pkgs.writeShellScriptBin "zj" ''
    #!${pkgs.bash}/bin/bash

    # If session name provided, attach to that specific session
    if [[ $1 != "" ]]; then
      SESSION="$1"
      shift
      ${pkgs.zellij}/bin/zellij attach "$SESSION" || ${pkgs.zellij}/bin/zellij --session "$SESSION" "$@"
      exit $?
    fi

    # No session name provided - find first unattached session
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
    else
      # No unattached sessions, create new one with default name "main"
      echo "Creating new session: main"
      ${pkgs.zellij}/bin/zellij "$@"
    fi
  '';

  zoxide-rm = pkgs.writeScriptBin "zoxide-rm" ''
    #!${pkgs.bash}/bin/bash
    EXP=$(echo "$1" | sed "s|~|$HOME|g")
    ${pkgs.zoxide}/bin/zoxide remove "$EXP"
  '';

in
{
  config = mkIf (cfg.enable && cfg.zellij.enable)
    {
      home.packages =
        let
          optionalPkgs = optionals cfg.zellij.install [ pkgs.zellij ];
          external = with pkgs; [
            zesh
            zoxide
            fzf
            gnugrep
            gnused
            gawk
            coreutils
            procps
            bc
            kdlfmt
          ];
        in
        [
          zj
          zoxide-rm
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
      # https://github.com/liam-mackie/zsm/releases/download/v0.1.0/zsm.wasm
      xdg.configFile."zellij/plugins/zsm.wasm".source = pkgs.fetchurl {
        url = "https://github.com/liam-mackie/zsm/releases/download/v0.1.0/zsm.wasm";
        sha256 = "sha256-sLkxWA4geqGd741/5ZM33Q7tZnTZSjBtec4NSjgJt+4=";
      };
      # https://github.com/dj95/zjstatus/releases/download/v0.22.0/zjstatus.wasm
      xdg.configFile."zellij/plugins/zjstatus.wasm".source = pkgs.fetchurl {
        url = "https://github.com/dj95/zjstatus/releases/download/v0.22.0/zjstatus.wasm";
        sha256 = "sha256-TeQm0gscv4YScuknrutbSdksF/Diu50XP4W/fwFU3VM=";
      };
    };
}
