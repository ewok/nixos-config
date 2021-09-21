{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.home.dev;
  gui = config.home.gui;
  fonts = config.home.theme.fonts;

  # master = import inputs.master (
  #   {
  #     config = config.nixpkgs.config;
  #     localSystem = { system = "x86_64-linux"; };
  #   }
  # );

in
{
  config = mkIf (dev.enable && gui.enable) {

    home.packages = [ pkgs.zeal ];

    xdg.configFile."Zeal/Zeal.css".text = ''
      iframe {
          -webkit-filter: invert()
      }
      html {
          -webkit-filter: invert() hue-rotate(180deg) contrast(80%) brightness(120%) contrast(85%); 
      }
      html img[src*=\"jpg\"], html img[src*=\"jpeg\"], html img[src*=\"jpg\"], html img[src*=\"jpeg\"] { 
          -webkit-filter: brightness(100%) contrast(100%);
      }
    '';

    xdg.configFile."Zeal/Zeal.conf".text = ''
      [General]
      check_for_update=true
      hide_on_close=false
      minimize_to_systray=false
      show_systray_icon=false
      start_minimized=false

      [content]
      custom_css_file=${config.xdg.configHome}/Zeal/Zeal.css
      dark_mode=true
      default_fixed_font_size=${toString fonts.monospaceFontSize}
      default_font_family=serif
      default_font_size=16
      disable_ad=true
      external_link_policy=@Variant(\0\0\0\x7f\0\0\0)Zeal::Core::Settings::ExternalLinkPolicy\0\0\0\0\0)
      fixed_font_family=${fonts.monospaceFont}
      highlight_on_navigate=true
      minimum_font_size=0
      sans_serif_font_family=Bitstream Vera Sans
      serif_font_family=Bitstream Vera Serif
      smooth_scrolling=false

      [docsets]
      path=${config.xdg.dataHome}/Zeal/Zeal/docsets

      [internal]
      install_id=aab172e7-f1ab-468c-8a41-b3f92a5cd578
      version=0.6.999

      [global_shortcuts]
      show=Alt+Shift+Z

      [search]
      fuzzy_search_enabled=true

      [state]
      splitter_geometry=@ByteArray(\0\0\0\xff\0\0\0\x1\0\0\0\x2\0\0\x1\x8b\0\0\x2\xe0\0\xff\xff\xff\xff\x1\0\0\0\x1\0)
      toc_splitter_state=@ByteArray()
      window_geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\b\xf6\0\0\0 \0\0\rh\0\0\x5\x98\0\0\b\xf8\0\0\0\"\0\0\rf\0\0\x5\x96\0\0\0\0\0\0\0\0\rp\0\0\b\xf8\0\0\0\"\0\0\rf\0\0\x5\x96)

      [tabs]
      open_new_tab_after_active=false
    '';
  };
}
