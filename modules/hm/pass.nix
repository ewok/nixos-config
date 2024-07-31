{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.opt.pass;
in
{
  options.opt.pass = {
    enable = mkEnableOption "pass";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      pass
    ];
  };
}
