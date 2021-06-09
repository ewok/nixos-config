{ config, lib, pkgs, inputs, ... }:
with lib;
let
  dev = config.modules.dev;
  username = config.properties.user.name;

  svnRmRm = pkgs.writeShellScriptBin "svn-rm-rm" ''
    svn st | grep ! | cut -d! -f2| sed 's/^ *//' | sed 's/^/"/g' | sed 's/$/"/g'  | xargs svn rm
  '';
in
{
  config = mkIf dev.enable {
    home-manager.users."${username}" = {
      home.packages = with pkgs; [ subversionClient svnRmRm ];
    };
  };
}
