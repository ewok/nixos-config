{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.apps;
  hm = config.home-manager.users."${cfg.username}";
in
  {
    options.opt.apps = {
      enable = mkOption { type = types.bool; };
      username = mkOption { type = types.str; };

      books = mkOption { type = types.bool; };
      db = mkOption { type = types.bool; };
      edu = mkOption { type = types.bool; };
      gaming = mkOption { type = types.bool; };
      music = mkOption { type = types.bool; };
      office = mkOption { type = types.bool; };
      video = mkOption { type = types.bool; };
      zeal = mkOption { type = types.bool; };
      vpn = mkOption { type = types.bool; };

      fonts = {
        dpi = mkOption {
          type = types.int;
          description = "Font DPI.";
        };
        regularFont = mkOption {
          type = types.str;
          description = "Default regular font.";
        };
        regularFontSize = mkOption {
          type = types.int;
          description = "Default regular font size.";
        };
        monospaceFont = mkOption {
          type = types.str;
          description = "Default monospace font.";
        };
        monospaceFontSize = mkOption {
          type = types.int;
          description = "Default monospace font size.";
        };
        consoleFont = mkOption {
          type = types.str;
          description = "Default console font.";
        };
      };
    };
    config = mkMerge [
      (
        mkIf cfg.enable {
          home-manager.users."${cfg.username}" = {
            home.packages = with pkgs; [
            ] ++
            optionals (cfg.books) [
              calibre
              epr
            ] ++
            optionals (cfg.db) [
              dbeaver
            ] ++
            optionals (cfg.edu) [
              anki
              goldendict
            ] ++
            optionals (cfg.gaming) [
              steam
            ] ++
            optionals (cfg.music) [
              playerctl
              cider
            ] ++
            optionals (cfg.video) [
              vlc
            ] ++
            optionals (cfg.vpn) [
              mullvad-vpn
            ];
          };
        })
        (mkIf (cfg.enable && cfg.zeal) {
          home-manager.users."${cfg.username}" = {
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
              custom_css_file=${hm.xdg.configHome}/Zeal/Zeal.css
              dark_mode=true
              default_fixed_font_size=${toString cfg.fonts.monospaceFontSize}
              default_font_family=serif
              default_font_size=16
              disable_ad=true
              external_link_policy=@Variant(\0\0\0\x7f\0\0\0)Zeal::Core::Settings::ExternalLinkPolicy\0\0\0\0\0)
              fixed_font_family=${cfg.fonts.monospaceFont}
              highlight_on_navigate=true
              minimum_font_size=0
              sans_serif_font_family=Bitstream Vera Sans
              serif_font_family=Bitstream Vera Serif
              smooth_scrolling=false

              [docsets]
              path=${hm.xdg.dataHome}/Zeal/Zeal/docsets

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
        })
        (mkIf (cfg.enable && cfg.office) {
          home-manager.users."${cfg.username}" = {
            home.packages = with pkgs; [
              libreoffice-fresh
            ];

            xdg.mimeApps.defaultApplications = lib.genAttrs [
              "application/vnd.oasis.opendocument.spreadsheet"
              "application/vnd.oasis.opendocument.spreadsheet-template"
              "application/vnd.sun.xml.calc"
              "application/vnd.sun.xml.calc.template"
              "application/msexcel"
              "application/vnd.ms-excel"
              "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
              "application/vnd.ms-excel.sheet.macroEnabled.12"
              "application/vnd.openxmlformats-officedocument.spreadsheetml.template"
              "application/vnd.ms-excel.template.macroEnabled.12"
              "application/vnd.ms-excel.sheet.binary.macroEnabled.12"
              "text/csv"
              "application/x-dbf"
              "text/spreadsheet"
              "application/csv"
              "application/excel"
              "application/tab-separated-values"
              "application/vnd.lotus-1-2-3"
              "application/vnd.oasis.opendocument.chart"
              "application/vnd.oasis.opendocument.chart-template"
              "application/x-dbase"
              "application/x-dos_ms_excel"
              "application/x-excel"
              "application/x-msexcel"
              "application/x-ms-excel"
              "application/x-quattropro"
              "application/x-123"
              "text/comma-separated-values"
              "text/tab-separated-values"
              "text/x-comma-separated-values"
              "text/x-csv"
              "application/vnd.oasis.opendocument.spreadsheet-flat-xml"
              "application/vnd.ms-works"
              "application/clarisworks"
              "application/x-iwork-numbers-sffnumbers"
              "application/x-starcalc"

            ] (_: [ "calc.desktop" ]) // lib.genAttrs [
              "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
              "application/vnd.oasis.opendocument.text"
              "application/vnd.oasis.opendocument.text-template"
              "application/vnd.oasis.opendocument.text-web"
              "application/vnd.oasis.opendocument.text-master"
              "application/vnd.oasis.opendocument.text-master-template"
              "application/vnd.sun.xml.writer"
              "application/vnd.sun.xml.writer.template"
              "application/vnd.sun.xml.writer.global"
              "application/msword"
              "application/vnd.ms-word"
              "application/x-doc"
              "application/x-hwp"
              "application/rtf"
              "text/rtf"
              "application/vnd.wordperfect"
              "application/wordperfect"
              "application/vnd.lotus-wordpro"
              "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
              "application/vnd.ms-word.document.macroEnabled.12"
              "application/vnd.openxmlformats-officedocument.wordprocessingml.template"
              "application/vnd.ms-word.template.macroEnabled.12"
              "application/vnd.ms-works"
              "application/vnd.stardivision.writer-global"
              "application/x-extension-txt"
              "application/x-t602"
              "text/plain"
              "application/vnd.oasis.opendocument.text-flat-xml"
              "application/x-fictionbook+xml"
              "application/macwriteii"
              "application/x-aportisdoc"
              "application/prs.plucker"
              "application/vnd.palm"
              "application/clarisworks"
              "application/x-sony-bbeb"
              "application/x-abiword"
              "application/x-iwork-pages-sffpages"
              "application/x-mswrite"
              "application/x-starwriter"
            ] (_: [ "writer.desktop" ]);
          };
        }
        )
      ];
    }

