{ config, lib, pkgs, ... }:
with lib;
let
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
