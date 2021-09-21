{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.home.gui;
in
{
  config = mkIf gui.enable {
home.sessionVariables.LOCALES_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    home.packages = with pkgs; [
      caffeine-ng
      xclip
      xsel
      glibcLocales
    ];
  };
}
