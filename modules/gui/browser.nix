{ config, lib, pkgs, inputs, firefox, ... }:
with lib;
let
  gui = config.modules.gui;
  colors = config.properties.theme.colors;
  username = config.properties.user.name;
  mitmproxy-local-stop = pkgs.writeShellScriptBin "mitmproxy-local-stop" ''
    /run/current-system/sw/bin/pkill -f '.*.mitmdump-wrapped -p 8080 --listen-host 127.0.0.1 -k.*'
  '';

  mitmproxy-local-start = pkgs.writeShellScriptBin "mitmproxy-local-start" ''
    ${pkgs.mitmproxy}/bin/mitmdump -p 8080 --listen-host 127.0.0.1 -k > /dev/null
  '';

  chooseBrowser = pkgs.writeShellScriptBin "choose-browser" ''
    CMD=$(echo "firefox|qutebrowser|google-chrome-stable" | rofi_run -dmenu -i -l 20 -p "Open url in:" -sep "|")
    $CMD "$1"
  '';

in
{
  config = mkIf gui.enable {

    home-manager.users.${username} = {

    home.sessionVariables = { "BROWSER" = "choose-browser"; };

      home.packages = with pkgs; [
        # For Google Meet
        google-chrome

        xsel
        mitmproxy-local-start
        mitmproxy-local-stop
        chooseBrowser

        (
          makeDesktopItem {
            name = "org.custom.qutebrowser.windowed";
            type = "Application";
            exec = "qutebrowser --target window %U";
            comment = "Qutebrowser that opens links preferably in new windows";
            desktopName = "QuteBrowser";
            categories = lib.concatStringsSep ";" [ "Network" "WebBrowser" ];
          }
        )

        (
          makeDesktopItem {
            name = "org.custom.choose.browser";
            type = "Application";
            exec = "choose-browser %U";
            comment = "Choose browser to open URL";
            desktopName = "ChooseBrowser";
            categories = lib.concatStringsSep ";" [ "Network" "WebBrowser" ];
          }
        )

      ];

      programs.firefox = {
        enable = true;

        profiles = {
          options = {
            name = "${username}";
            id = 0;
            settings = {
              "browser.startup.homepage" = "about:blank";
              "browser.search.isUS" = true;
              "browser.bookmarks.showMobileBookmarks" = true;
              "browser.bookmarks.restore_default_bookmarks" = false;
              "browser.cache.disk.parent_directory" = "/tmp/firefox";
              "browser.tabs.warnOnClose" = false;
              "browser.urlbar.suggest.history" = false;
              "browser.urlbar.suggest.searches" = false;

              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              "services.sync.prefs.sync.browser.uiCustomization.state" = true;

              "browser.download.animateNotifications" = false;
              "media.autoplay.default" = 1;
              "findbar.highlightAll" = true;
              "layout.spellcheckDefault" = true;
              "browser.urlbar.trimURLs" = false;
              "browser.urlbar.formatting.enabled" = false;

              # Some security twiks
              "network.http.speculative-parallel-limit" = 0;
              "geo.enabled" = false;
              "geo.wifi.logging.enabled" = false;
              "browser.search.countryCode" = "";
              "browser.search.region" = "";

              "dom.event.clipboardevents.enabled" = false;
              "dom.event.contextmenu.enabled" = false;
              "webgl.disabled" = true;

              "extensions.pocket.enabled" = false;
              "browser.pocket.api" = "";
              "browser.pocket.oAuthConsumerKey" = "";
              "browser.pocket.site" = "";
              "geo.wifi.uri" = "";
              "browser.safebrowsing.appRepURL" = "";
              "browser.safebrowsing.gethashURL" = "";
              "browser.safebrowsing.malware.reportURL" = "";
              "browser.safebrowsing.reportURL" = "";
              "browser.safebrowsing.updateURL" = "";

              "network.dns.disablePrefetch" = true;
              "network.prefetch-next" = false;
              "beacon.enabled" = false;

              # "content.notify.ontimer" = true;
              # "content.notify.interval" = 500000;
              # "browser.sessionstore.interval" = 60000;

            } // optionalAttrs (gui.touchscreen.enable) {
              "dom.w3c_touch_events.enabled" = true;
            };
            userChrome = ''
              #TabsToolbar {
                visibility: collapse !important;
                margin-bottom: 21px !important;
              }
            '';
            isDefault = true;
          };
        };
      };

      programs.qutebrowser = {
        enable = true;
        aliases = {
          jsd = "set content.javascript.enabled false";
          jse = "set content.javascript.enabled true";
          proxym = "set content.proxy http://127.0.0.1:8080/";
          noproxym = "set content.proxy system";
        };
        settings = {
          auto_save = {
            interval = 15000;
            session = true;
          };
          zoom = {
            default = "140%";
            levels = [
              "25%"
              "33%"
              "50%"
              "67%"
              "75%"
              "90%"
              "100%"
              "110%"
              "125%"
              "140%"
              "150%"
              "175%"
              "200%"
              "250%"
              "300%"
              "400%"
              "500%"
            ];
          };
          colors = {
            # statusbar.url.success.https.fg = "white";
            # tabs = rec {
            #   even.bg = "#49505E";
            #   even.fg = "#639EE4";
            #   odd.bg = "#35383F";
            #   odd.fg = even.fg;
            #   bar.bg = "#303030";
            # };
            webpage = {
              preferred_color_scheme = "dark";
              # bg = "#303030";
              darkmode.enabled = true;
              darkmode.policy.images = "never";
              # lightness-cielab lightness-hsl brightness-rgb
              darkmode.algorithm = "lightness-cielab";

            };
          };
          completion = {
            height = "20%";
            quick = false;
            show = "auto";
            shrink = true;
            timestamp_format = "%d-%m-%Y";
            use_best_match = false;
          };
          confirm_quit = [ "downloads" ];
          content = {
            autoplay = false;
            cache = {
              appcache = true;
              size = 5242880;
            };
            canvas_reading = true;
            cookies.store = true;
            geolocation = "ask";
            javascript.enabled = true;
            mute = true;
            notifications.enabled = true;
            pdfjs = true;
            plugins = true;
            proxy = "none";
            register_protocol_handler = true;
            tls = {
              certificate_errors = "block";
            };
            webgl = true;
          };
          downloads = {
            location = {
              directory = "~/Downloads";
              prompt = false;
              remember = true;
              suggestion = "both";
            };
          };
          history_gap_interval = 30;
          input = {
            insert_mode = {
              auto_leave = true;
              auto_load = false;
              plugins = false;
            };
            links_included_in_focus_chain = true;
            partial_timeout = 10000;
            spatial_navigation = false;
          };
          keyhint.delay = 20;
          new_instance_open_target = "tab";
          new_instance_open_target_window = "last-focused";
          prompt.filebrowser = true;
          scrolling = {
            bar = "always";
            smooth = true;
          };
          search.ignore_case = "smart";
          session.lazy_restore = true;
          statusbar = {
            widgets = [ "keypress" "url" "history" "tabs" "progress" ];
          };
          tabs = {
            background = true;
            last_close = "close";
            new_position = {
              related = "next";
              unrelated = "last";
            };
            position = "left";
            select_on_remove = "next";
            show = "multiple";
            tabs_are_windows = false;
            title = {
              format = "{audio}{current_title}";
              format_pinned = "{audio}";
            };
          };
          url = {
            auto_search = "dns";
            default_page = "about:blank";
            incdec_segments = [ "path" "query" ];
            yank_ignored_parameters = [ "ref" "utm_source" "utm_medium" "utm_campaign" "utm_term" "utm_content" ];
            start_pages = [ "about:blank" ];
          };
          window.title_format = "{private}{perc}{current_title}{title_sep}qutebrowser | {current_url}";
        };
        searchEngines = {
          DEFAULT = "https://www.google.com/search?q={}";
          d = "https://duckduckgo.com/?q={}";
          n = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&query={}";
          y = "https://www.youtube.com/results?search_query={}";
          w = "https://www.merriam-webster.com/dictionary/{}";
        };
        keyBindings = {
          normal = {
            "<space>tt" = "config-cycle tabs.show multiple never";
            "<space>bb" = "bookmark-list";
            "<space>bn" = "set-cmd-text -s :quickmark-add {url}";
            "<space>bd" = "quickmark-del";
            "<space>C" = "clear-messages";
            "<space>dd" = "download";
            "<space>dc" = "download-cancel";
            "<space>dC" = "download-clear";
            "<space>dr" = "download-retry";
            "<space>gm" = "open https://mail.google.com";
            "<space>gc" = "open https://calendar.google.com";
            "<space>gy" = "open https://youtube.com";
            "<space>gg" = "open https://google.com";
            "<Ctrl-e>" = "scroll-px 0 20";
            "<Ctrl-y>" = "scroll-px 0 -20";
            "<space>ss" = "set-cmd-text -s :session-save -o ";
            "<space>so" = "set-cmd-text -s :session-load -t";
            "<space>sd" = "set-cmd-text -s :session-delete ";
            "<Ctrl-1>" = "tab-focus 1";
            "<Ctrl-2>" = "tab-focus 2";
            "<Ctrl-3>" = "tab-focus 3";
            "<Ctrl-4>" = "tab-focus 4";
            "<Ctrl-5>" = "tab-focus 5";
            "<Ctrl-6>" = "tab-focus 6";
            "<Ctrl-7>" = "tab-focus 7";
            "<Ctrl-8>" = "tab-focus 8";
            "<Ctrl-9>" = "tab-focus 9";
            "<Ctrl-m>" = "tab-mute";
            "wc" = "close";
            "wq" = "close";
            "to" = "tab-only";
            "gT" = "set-cmd-text -s :tab-take";
            "si" = "set -u *://{url:host}/* content.tls.certificate_errors load-insecurely";
            "sI" = "set -u *://{url:host}/* content.tls.certificate_errors block";
            "<space>pr" = "proxym";
            "<space>ps" = "noproxym";
            "<space>pm" = "spawn mitmproxy-local-start";
            "<space>pM" = "spawn mitmproxy-local-stop";
            "yd" = "yank inline {url:host}";
            "yD" = "yank inline {url:host} -s";
            "gB" = "tab-give";
            "gj" = "tab-move +";
            "gk" = "tab-move -";
            "dd" = "tab-close";
            "rr" = "reload";
            "wv" = "spawn vlc {url}";
            "pw" = "spawn --userscript qute_1pass --cache-session fill_credentials";
          };
          insert = {
            "<Ctrl-y>" = "insert-text -- {clipboard}";
            "<Alt-Shift-u>" = "spawn --userscript qute_1pass --cache-session fill_username";
            "<Alt-Shift-p>" = "spawn --userscript qute_1pass --cache-session fill_password";
            "<Alt-Shift-t>" = "spawn ykman-otp";
            # "<Alt-Shift-t>" = "spawn --userscript qute_1pass --cache-session fill_totp";
          };
          command = {
            "<Ctrl-j>" = "completion-item-focus --history next";
            "<Ctrl-k>" = "completion-item-focus --history prev";
            "<Ctrl-m>" = "command-accept";
          };
        };
        extraConfig = ''
          config.unbind('d', mode='normal')
          config.unbind('r', mode='normal')
          config.set('content.javascript.enabled', True, 'chrome://*/*')
          config.set('content.javascript.enabled', True, 'file://*')
          config.set('content.javascript.enabled', True, 'qute://*/*')
          config.load_autoconfig(False)
          c.bindings.key_mappings = {
              'Й': 'Q', 'й': 'q',
              'Ц': 'W', 'ц': 'w',
              'У': 'E', 'у': 'e',
              'К': 'R', 'к': 'r',
              'Е': 'T', 'е': 't',
              'Н': 'Y', 'н': 'y',
              'Г': 'U', 'г': 'u',
              'Ш': 'I', 'ш': 'i',
              'Щ': 'O', 'щ': 'o',
              'З': 'P', 'з': 'p',
              'Х': '{', 'х': '[',
              'Ъ': '}', 'ъ': ']',
              'Ф': 'A', 'ф': 'a',
              'Ы': 'S', 'ы': 's',
              'В': 'D', 'в': 'd',
              'А': 'F', 'а': 'f',
              'П': 'G', 'п': 'g',
              'Р': 'H', 'р': 'h',
              'О': 'J', 'о': 'j',
              'Л': 'K', 'л': 'k',
              'Д': 'L', 'д': 'l',
              'Ж': ':', 'ж': ';',
              'Э': '"', 'э': '\''',
              'Я': 'Z', 'я': 'z',
              'Ч': 'X', 'ч': 'x',
              'С': 'C', 'с': 'c',
              'М': 'V', 'м': 'v',
              'И': 'B', 'и': 'b',
              'Т': 'N', 'т': 'n',
              'Ь': 'M', 'ь': 'm',
              'Б': '<', 'б': ',',
              'Ю': '>', 'ю': '.',
              ',': '?', '.': '/',
          }
          ${replaceStrings [
          "base00 ="
          "base01 ="
          "base02 ="
          "base03 ="
          "base04 ="
          "base05 ="
          "base06 ="
          "base07 ="
          "base08 ="
          "base09 ="
          "base0A ="
          "base0B ="
          "base0C ="
          "base0D ="
          "base0E ="
          "base0F ="
        ] [
          ''base00 = "#${colors.color0}"''
          ''base01 = "#${colors.color10}"''
          ''base02 = "#${colors.color11}"''
          ''base03 = "#${colors.color8}"''
          ''base04 = "#${colors.color12}"''
          ''base05 = "#${colors.color7}"''
          ''base06 = "#${colors.color13}"''
          ''base07 = "#${colors.color15}"''
          ''base08 = "#${colors.color1}"''
          ''base09 = "#${colors.color9}"''
          ''base0A = "#${colors.color3}"''
          ''base0B = "#${colors.color2}"''
          ''base0C = "#${colors.color6}"''
          ''base0D = "#${colors.color4}"''
          ''base0E = "#${colors.color5}"''
          ''base0F = "#${colors.color14}"''
        ]
          (readFile ./config/qutebrowser.py)}
        '';
      };

      xdg.configFile."qutebrowser/userscripts/qute_1pass" = {
        source = ./config/qute-1pass.py;
        executable = true;
      };

      xdg.mimeApps.defaultApplications = lib.genAttrs [
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "application/x-extension-htm"
        "application/x-extension-html"
        "application/x-extension-shtml"
        "application/xhtml+xml"
        "application/x-extension-xht"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
      ] (_: [ "org.custom.choose.browser.desktop" ]);

    };
  };
}
