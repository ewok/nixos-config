{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.home.gui;
  cfg = config.home.theme.fonts;
  username = config.home.username;
in
{
  config = mkIf gui.enable {

    # fonts = {
    #   fontconfig = {
    #     enable = true;
    #     # antialias = true;
    #     # dpi = cfg.dpi;
    #     # defaultFonts.monospace = [ cfg.monospaceFont ];
    #   };

    #   # fontDir.enable = true;
    #   # enableGhostscriptFonts = true;
    #   # enableDefaultFonts = true;

    #   # fonts = with pkgs; [ nerdfonts ];
    # };

    # console = {
    #   font = cfg.consoleFont;
    #   useXkbConfig = true;
    # };

      xresources.properties = {
        "Xft.antialias" = true;
        "Xft.autohint" = false;
        "Xft.dpi" = "${toString cfg.dpi}";
        "Xft.hinting" = true;
        "Xft.hintstyle" = "hintmedium";
      };
    };
}
