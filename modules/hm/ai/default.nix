{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (pkgs) stdenv;

  cfg = config.opt.ai;
in
{
  options.opt.ai = {
    enable = mkEnableOption "AI terminal tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      github-copilot-cli
      codex
      opencode
    ];
  };
}
