{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.opt.tf;
in
{
  options.opt.tf = {
    enable = mkEnableOption "tf";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      tenv
      tfautomv
    ];

  };
}
