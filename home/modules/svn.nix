{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.home.dev;
  svnRmRm = pkgs.writeShellScriptBin "svn-rm-rm" ''
    svn st | grep ! | cut -d! -f2| sed 's/^ *//' | sed 's/^/"/g' | sed 's/$/"/g'  | xargs svn rm
  '';
in
{
  config = mkIf dev.enable {
    home.packages = with pkgs; [ subversionClient svnRmRm ];
  };
}
