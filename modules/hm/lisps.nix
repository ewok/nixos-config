{ config, lib, pkgs, ... }:
let
  cfg = config.opt.lisps;
in
{
  options.opt.lisps = {
    enable = lib.mkEnableOption "lisps";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      clojure
      clojure-lsp
      clj-kondo
      babashka-unwrapped
      leiningen
    ];
  };
}
