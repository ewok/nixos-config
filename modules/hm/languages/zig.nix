{ config, lib, pkgs, ... }:
let
  cfg = config.opt.languages.zig;
in
{
  options.opt.languages.zig = {
    enable = lib.mkEnableOption "zig";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zig
    ];
    # home.file.".zig".text = ''
    # '';
  };
}
