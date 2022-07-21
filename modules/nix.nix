{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.nix;
in
{
  options.opt.nix = {
    enable = mkEnableOption "nix";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nix-tree
    ];
  };
}
