{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.svn;
  svn-rm-rm = pkgs.writeScriptBin "svn-rm-rm" ''
    #!/usr/bin/env bash
    if [[ -n "$(command -v -- svn)" ]]
    then
    CMD=svn
    else
    echo "svn not found"
    exit 1
    fi
    $CMD st | grep ! | cut -d! -f2| sed 's/^ *//' | sed 's/^/"/g' | sed 's/$/"/g'  | xargs $CMD rm
  '';

  svn-add-add = pkgs.writeScriptBin "svn-add-add" ''
    #!/usr/bin/env bash
    if [[ -n "$(command -v -- svn)" ]]
    then
    CMD=svn
    else
    echo "svn not found"
    exit 1
    fi
    $CMD st | grep '?' | cut -d'?' -f2| sed 's/^ *//' | sed 's/^/"/g' | sed 's/$/"/g' | xargs $CMD add
  '';
in
{
  options.opt.svn = {
    enable = mkEnableOption "svn";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        subversion
        svn-add-add
        svn-rm-rm
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
