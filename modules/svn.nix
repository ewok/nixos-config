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
    };
  };
}
