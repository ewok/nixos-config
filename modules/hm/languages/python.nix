{ config, lib, pkgs, ... }:
let
  cfg = config.opt.languages.python;
in
{
  options.opt.languages.python = {
    enable = lib.mkEnableOption "python";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      pyright
      black
      joker
      # python311Packages.autopep8
    ];
  };
}
