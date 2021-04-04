{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  cfg = config.modules.gui.fonts;
  username = config.properties.user.name;
in
{
  options.modules.gui.fonts = {
    dpi = mkOption {
      type = types.int;
      default = 115;
      description = "Font DPI.";
    };
    monospaceFont = mkOption {
      type = types.listOf types.str;
      default = [ "FiraCode Nerd Font Mono" ];
      description = "Default monospace font.";
    };
    monospaceFontSize = mkOption {
      type = types.int;
      default = 14;
      description = "Default monospace font size.";
    };
    consoleFont = mkOption {
      type = types.str;
      default = "Lat2-Terminus16";
      description = "Default console font.";
    };
  };

  config = mkIf gui.enable {

    fonts = {
      fontconfig = {
        enable = true;
        antialias = true;
        dpi = cfg.dpi;
        defaultFonts.monospace = cfg.monospaceFont;
      };

      fontDir.enable = true;
      enableGhostscriptFonts = true;
      enableDefaultFonts = true;

      fonts = with pkgs; [ nerdfonts ];
    };

    console = {
      font = cfg.consoleFont;
      useXkbConfig = true;
    };

    home-manager.users.${username} = {

      xresources.properties = {
        "Xft.antialias" = true;
        "Xft.autohint" = false;
        "Xft.dpi" = "${toString cfg.dpi}";
        "Xft.hinting" = true;
        "Xft.hintstyle" = "hintmedium";
      };
      xresources.extraConfig = ''
        ! Base16 OneDark
        ! Scheme: Lalit Magant (http://github.com/tilal6991)

        #define base00 #282c34
        #define base01 #353b45
        #define base02 #3e4451
        #define base03 #545862
        #define base04 #565c64
        #define base05 #abb2bf
        #define base06 #b6bdca
        #define base07 #c8ccd4
        #define base08 #e06c75
        #define base09 #d19a66
        #define base0A #e5c07b
        #define base0B #98c379
        #define base0C #56b6c2
        #define base0D #61afef
        #define base0E #c678dd
        #define base0F #be5046

        *foreground:   base05
        #ifdef background_opacity
        *background:   [background_opacity]base00
        #else
        *background:   base00
        #endif
        *cursorColor:  base05

        *color0:       base00
        *color1:       base08
        *color2:       base0B
        *color3:       base0A
        *color4:       base0D
        *color5:       base0E
        *color6:       base0C
        *color7:       base05

        *color8:       base03
        *color9:       base09
        *color10:      base01
        *color11:      base02
        *color12:      base04
        *color13:      base06
        *color14:      base0F
        *color15:      base07
      '';
    };
  };
}
