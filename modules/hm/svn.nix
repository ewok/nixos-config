{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (pkgs) writeScriptBin;

  cfg = config.opt.svn;
  svn-rm-rm = writeScriptBin "svn-rm-rm" ''
    #!/usr/bin/env bash
    if [[ -n "$(command -v -- svn)" ]]
    then
    CMD=svn
    else
    echo "svn not found"
    exit 1
    fi
    $CMD st | grep ! | cut -d! -f2| sed 's/^ *//' | sed 's/^/"/g' | sed 's/$/"/g'  | xargs $CMD rm 2>/dev/null
  '';

  svn-add-add = writeScriptBin "svn-add-add" ''
    #!/usr/bin/env bash
    if [[ -n "$(command -v -- svn)" ]]
    then
    CMD=svn
    else
    echo "svn not found"
    exit 1
    fi
    $CMD st | grep '?' | cut -d'?' -f2| sed 's/^ *//' | sed 's/^/"/g' | sed 's/$/"/g' | xargs $CMD add 2>/dev/null
  '';

  svn-update = writeScriptBin "svn-update" ''
    #!/usr/bin/env bash
    if [[ -n "$(command -v -- svn)" ]]
    then
    CMD=svn
    else
    echo "svn not found"
    exit 1
    fi
    $CMD st | grep '?' | cut -d'?' -f2| sed 's/^ *//' | sed 's/^/"/g' | sed 's/$/"/g' | xargs $CMD add 2>/dev/null || true
    $CMD st | grep ! | cut -d! -f2| sed 's/^ *//' | sed 's/^/"/g' | sed 's/$/"/g'  | xargs $CMD rm 2>/dev/null || true
    svn up || true
    svn commit -m update || true
    svn status
  '';
in
{
  options.opt.svn = {
    enable = mkEnableOption "svn";
  };

  config = mkIf cfg.enable {
    home =
      {
        packages =
          let
            external = with pkgs; [
              subversion
            ];
          in
          external ++ [
            svn-add-add
            svn-rm-rm
            svn-update
          ];
      };

    home.file.".subversion/config".text = ''
      [auth]
      [helpers]
      [tunnels]
      [miscellany]
      global-ignores = *.o *.lo *.la *.al .libs *.so *.so.[0-9]* *.a *.pyc *.pyo __pycache__ .terraform .direnv .venv .vscode .clj-kondo .lsp .nrepl-port iced_stdout target .cpcache
      [auto-props]
      [working-copy]
    '';
  };
}
