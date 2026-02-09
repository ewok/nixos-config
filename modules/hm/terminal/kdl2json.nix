{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  
  cfg = config.opt.terminal;
  
  kdl2json = pkgs.callPackage ./kdl2json { };
in
{
  config = mkIf cfg.enable {
    home.packages = [ kdl2json ];
  };
}
