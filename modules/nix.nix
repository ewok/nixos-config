{ config, lib, pkgs, ... }:
let
  cfg = config.opt.nix;
in
{
  options.opt.nix = {
    enable = lib.mkEnableOption "nix";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nix-tree
      # cachix use nix-community
      cachix
    ];
  };
}
