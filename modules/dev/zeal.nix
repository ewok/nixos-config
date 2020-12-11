{ config, lib, pkgs, ... }:
with lib;
let
  dev = config.modules.dev;
  gui = config.modules.gui;
  username = config.properties.user.name;
  dataHome = config.home-manager.users.${username}.xdg.dataHome;
in
{
  config = mkIf (dev.enable && gui.enable) {

    home-manager.users."${username}" = {
      home.packages = [ pkgs.zeal ];

      xdg.configFile."Zeal/Zeal.conf".text = ''
        [General]
        check_for_update=true
        hide_on_close=true
        minimize_to_systray=true
        show_systray_icon=true
        start_minimized=true

        [content]
        custom_css_file=
        dark_mode=true
        default_fixed_font_size=${toString gui.fonts.monospaceFontSize}
        default_font_family=serif
        default_font_size=16
        disable_ad=true
        external_link_policy=@Variant(\0\0\0\x7f\0\0\0)Zeal::Core::Settings::ExternalLinkPolicy\0\0\0\0\0)
        fixed_font_family=${last (reverseList gui.fonts.monospaceFont)}
        highlight_on_navigate=true
        minimum_font_size=0
        sans_serif_font_family=Bitstream Vera Sans
        serif_font_family=Bitstream Vera Serif
        smooth_scrolling=false

        [docsets]
        path=${dataHome}/Zeal/Zeal/docsets

        [global_shortcuts]
        show=Alt+Shift+Z

        # [internal]
        # install_id=3740b2fd-af47-4d79-aee3-4794de17fcc6
        # version=0.6.1

        [search]
        fuzzy_search_enabled=true

        # [state]
        # splitter_geometry=@ByteArray(\0\0\0\xff\0\0\0\x1\0\0\0\x2\0\0\x1\0\0\0\x4\xb0\0\xff\xff\xff\xff\x1\0\0\0\x1\0)
        # toc_splitter_state=@ByteArray()
        # window_geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\0\0\0\0\x2\xc6\0\0\t\xff\0\0\x4\x1d\0\0\0\x2\0\0\x2\xc8\0\0\t\xfd\0\0\x4\x1b\0\0\0\x1\0\0\0\0\n\0\0\0\0\x2\0\0\x2\xc8\0\0\t\xfd\0\0\x4\x1b)

        [tabs]
        open_new_tab_after_active=false
      '';
    };
  };
}
