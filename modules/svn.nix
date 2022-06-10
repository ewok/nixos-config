{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.svn;
  svnRmRm = pkgs.writeShellScriptBin "svn-rm-rm" ''
    svn st | grep ! | cut -d! -f2| sed 's/^ *//' | sed 's/^/"/g' | sed 's/$/"/g'  | xargs svn rm
  '';
in
{
  options.opt.svn.enable = mkOption { type = types.bool; };
  options.opt.svn.username = mkOption {type = types.str;};

  config = mkIf cfg.enable {
    home-manager.users.${cfg.username} = {
      home.packages = with pkgs; [ subversionClient svnRmRm ];

      home.file.".subversion/config".text = ''
        [auth]
        [helpers]
        [tunnels]
        [miscellany]
        global-ignores = *.o *.lo *.la *.al .libs *.so *.so.[0-9]* *.a *.pyc *.pyo __pycache__ .terraform .direnv .venv .vscode .clj-kondo .lsp .nrepl-port iced_stdout target
        [auto-props]
        [working-copy]
        '';
    };
  };
}
