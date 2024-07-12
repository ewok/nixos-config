{ config, lib, pkgs, ... }:
with lib;
let
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
