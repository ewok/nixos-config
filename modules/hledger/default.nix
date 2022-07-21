{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.hledger;
in
{
  options.opt.hledger = {
    enable = mkEnableOption "hledger";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        hledger
        babashka-unwrapped
        coreutils
      ];
      file."bin" = {
        source = ./config;
        executable = true;
        recursive = true;
      };
    };
  };
}
