{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.lisps;
in
{
  options.opt.lisps = {
    enable = mkEnableOption "lisps";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      clojure
      babashka-unwrapped
      leiningen
    ];
  };
}
