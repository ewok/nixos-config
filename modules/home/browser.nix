{ config, lib, pkgs, inputs, firefox, ... }:
with lib;
let
  cfg = config.opt.browser;

  mitmproxy-local-stop = pkgs.writeShellScriptBin "mitmproxy-local-stop" ''
    /run/current-system/sw/bin/pkill -f '.*.mitmdump-wrapped -p 8080 --listen-host 127.0.0.1 -k.*'
  '';

  mitmproxy-local-start = pkgs.writeShellScriptBin "mitmproxy-local-start" ''
    ${pkgs.mitmproxy}/bin/mitmdump -p 8080 --listen-host 127.0.0.1 -k > /dev/null
  '';

  chooseBrowser = pkgs.writeShellScriptBin "choose-browser" ''
    CMD=$(echo "firefox|google-chrome" | rofi_run -dmenu -i -l 20 -p "Open url in:" -sep "|")
    $CMD "$1"
  '';

in
{
  options.opt.browser = {
    enable = mkOption { type = types.bool; };
    username = mkOption { type = types.str; };
    touchscreen = mkOption { type = types.bool; };
    firefox.enable = mkOption { type = types.bool; };
    chrome.enable = mkOption { type = types.bool; };
    vivaldi.enable = mkOption { type = types.bool; };
    colors = {
      background = mkOption {
        type = types.str;
      };
      foreground = mkOption {
        type = types.str;
      };
      text = mkOption {
        type = types.str;
      };
      cursor = mkOption {
        type = types.str;
      };
        # Black
        color0 = mkOption {
          type = types.str;
        };
        # Red
        color1 = mkOption {
          type = types.str;
        };
        # Green
        color2 = mkOption {
          type = types.str;
        };
        # Yellow
        color3 = mkOption {
          type = types.str;
        };
        # Blue
        color4 = mkOption {
          type = types.str;
        };
        # Magenta
        color5 = mkOption {
          type = types.str;
        };
        # Cyan
        color6 = mkOption {
          type = types.str;
        };
        # White
        color7 = mkOption {
          type = types.str;
        };
        # Br Black
        color8 = mkOption {
          type = types.str;
        };
        # Br Red
        color9 = mkOption {
          type = types.str;
        };
        # Br Green
        color10 = mkOption {
          type = types.str;
        };
        # Br Yellow
        color11 = mkOption {
          type = types.str;
        };
        # Br Blue
        color12 = mkOption {
          type = types.str;
        };
        # Br Magenta
        color13 = mkOption {
          type = types.str;
        };
        # Br Cyan
        color14 = mkOption {
          type = types.str;
        };
        # Br White
        color15 = mkOption {
          type = types.str;
        };
      };
  };

  config = mkIf cfg.enable {

    home.sessionVariables = { "BROWSER" = "choose-browser"; };

    home.packages = with pkgs; [
      xsel
      mitmproxy-local-start
      mitmproxy-local-stop
      chooseBrowser

      # (
      #   makeDesktopItem {
      #     name = "org.custom.qutebrowser.windowed";
      #     type = "Application";
      #     exec = "qutebrowser --target window %U";
      #     comment = "Qutebrowser that opens links preferably in new windows";
      #     desktopName = "QuteBrowser";
      #     categories = lib.concatStringsSep ";" [ "Network" "WebBrowser" ];
      #   }
      # )

      (
        makeDesktopItem {
          name = "org.custom.choose.browser";
          type = "Application";
          exec = "choose-browser %U";
          comment = "Choose browser to open URL";
          desktopName = "ChooseBrowser";
          categories = [ "Network" "WebBrowser" ];
        }
      )
    ] ++
    optionals (cfg.chrome.enable) [
      # For Google Meet
      google-chrome
    ] ++
    optionals (cfg.vivaldi.enable) [
      # For Google Meet
      vivaldi
    ] ++
    optionals (cfg.firefox.enable) [
      (
        makeDesktopItem {
          name = "org.mozilla.firefox";
          type = "Application";
          exec = "firefox %U";
          comment = "Firefox";
          desktopName = "Firefox";
          categories = [ "Network" "WebBrowser" ];
        }
      )
    ];

    # Firefox Plugins
    home.file.".mozilla/firefox/${cfg.username}/extensions/treestyletab@piro.sakura.ne.jp.xpi".source = pkgs.fetchurl {
      url = "https://addons.mozilla.org/firefox/downloads/file/3956945/tree_style_tab-3.8.24.xpi";
      sha256 = "0p7dp5xixrz6x7466vbrg7i59xnwbjxqa5994za87zqi4d2b01lg";
    };
    home.file.".mozilla/firefox/${cfg.username}/extensions/{d634138d-c276-4fc8-924b-40a0ea21d284}.xpi".source = pkgs.fetchurl {
      url = "https://addons.mozilla.org/firefox/downloads/file/3957930/1password_x_password_manager-2.3.5.xpi";
      sha256 = "0yq6jmww4i7mx0mh9cz2yldxc900j9ziabv7kk4wfm4py88n7l9p";
    };
    home.file.".mozilla/firefox/${cfg.username}/extensions/addon@simplelogin.xpi".source = pkgs.fetchurl {
      url = "https://addons.mozilla.org/firefox/downloads/file/3952833/simplelogin-2.6.3.xpi";
      sha256 = "1ww3y1b1n2czim05r0l7141fj1z3di3q31v9n3w3bkq0zf1dgcqc";
    };
    home.file.".mozilla/firefox/${cfg.username}/extensions/addon@darkreader.org.xpi".source = pkgs.fetchurl {
      url = "https://addons.mozilla.org/firefox/downloads/file/3954503/darkreader-4.9.51.xpi";
      sha256 = "1ayk1abcbyk91cwsr0v7yid9p0xrh44ccpyi4wmgsn89lh64mf6z";
    };
    home.file.".mozilla/firefox/${cfg.username}/extensions/{019b606a-6f61-4d01-af2a-cea528f606da}.xpi".source = pkgs.fetchurl {
      url = "https://addons.mozilla.org/firefox/downloads/file/3546070/xbs-1.5.2.xpi";
      sha256 = "0882g9pijy1pd9z5rgcm8zxz9j9bil8azax53cdi4gi7k1aasn4b";
    };
    home.file.".mozilla/firefox/${cfg.username}/extensions/tst-wheel_and_double@dontpokebadgers.com.xpi".source = pkgs.fetchurl {
      url = "https://addons.mozilla.org/firefox/downloads/file/3473925/tree_style_tab_mouse_wheel-1.5.xpi";
      sha256 = "1d9b94y9ds44dzf7iy5sblzwpipp3pc5vljz8qip73mirqgxbfn9";
    };

    programs.firefox = {
      enable = cfg.firefox.enable;

      profiles = {
        options = {
          name = "${cfg.username}";
          path = "${cfg.username}";
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

            "dom.event.clipboardevents.enabled" = true;
            "dom.event.contextmenu.enabled" = true;
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

          } // optionalAttrs (cfg.touchscreen) {
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

    # programs.qutebrowser = {
    #   enable = true;
    #   package = master.qutebrowser;
    #   aliases = {
    #     jsd = "set content.javascript.enabled false";
    #     jse = "set content.javascript.enabled true";
    #     proxym = "set content.proxy http://127.0.0.1:8080/";
    #     noproxym = "set content.proxy system";
    #   };
    #   settings = {
    #     auto_save = {
    #       interval = 15000;
    #       session = true;
    #     };
    #     zoom = {
    #       default = "100%";
    #       levels = [
    #         "25%"
    #         "33%"
    #         "50%"
    #         "67%"
    #         "75%"
    #         "90%"
    #         "100%"
    #         "110%"
    #         "125%"
    #         "140%"
    #         "150%"
    #         "175%"
    #         "200%"
    #         "250%"
    #         "300%"
    #         "400%"
    #         "500%"
    #       ];
    #     };
    #     colors = {
    #       # statusbar.url.success.https.fg = "white";
    #       # tabs = rec {
    #       #   even.bg = "#49505E";
    #       #   even.fg = "#639EE4";
    #       #   odd.bg = "#35383F";
    #       #   odd.fg = even.fg;
    #       #   bar.bg = "#303030";
    #       # };
    #       webpage = {
    #         preferred_color_scheme = "dark";
    #         # bg = "#303030";
    #         darkmode.enabled = true;
    #         darkmode.policy.images = "never";
    #         # lightness-cielab lightness-hsl brightness-rgb
    #         darkmode.algorithm = "lightness-cielab";

    #       };
    #     };
    #     completion = {
    #       height = "20%";
    #       quick = false;
    #       show = "auto";
    #       shrink = true;
    #       timestamp_format = "%d-%m-%Y";
    #       use_best_match = false;
    #     };
    #     confirm_quit = [ "downloads" ];
    #     content = {
    #       autoplay = false;
    #       cache = {
    #         appcache = true;
    #         size = 5242880;
    #       };
    #       canvas_reading = true;
    #       cookies.store = true;
    #       geolocation = "ask";
    #       javascript.enabled = true;
    #       mute = true;
    #       notifications.enabled = true;
    #       pdfjs = true;
    #       plugins = true;
    #       proxy = "none";
    #       register_protocol_handler = true;
    #       tls = {
    #         certificate_errors = "block";
    #       };
    #       webgl = true;
    #     };
    #     downloads = {
    #       location = {
    #         directory = "~/Downloads";
    #         prompt = false;
    #         remember = true;
    #         suggestion = "both";
    #       };
    #     };
    #     history_gap_interval = 30;
    #     input = {
    #       insert_mode = {
    #         auto_leave = true;
    #         auto_load = false;
    #         plugins = false;
    #       };
    #       links_included_in_focus_chain = true;
    #       partial_timeout = 10000;
    #       spatial_navigation = false;
    #     };
    #     keyhint.delay = 20;
    #     new_instance_open_target = "tab";
    #     new_instance_open_target_window = "last-focused";
    #     prompt.filebrowser = true;
    #     scrolling = {
    #       bar = "always";
    #       smooth = true;
    #     };
    #     search.ignore_case = "smart";
    #     session.lazy_restore = true;
    #     statusbar = {
    #       widgets = [ "keypress" "url" "history" "tabs" "progress" ];
    #     };
    #     tabs = {
    #       background = true;
    #       last_close = "close";
    #       new_position = {
    #         related = "next";
    #         unrelated = "last";
    #       };
    #       position = "left";
    #       select_on_remove = "next";
    #       show = "multiple";
    #       tabs_are_windows = false;
    #       title = {
    #         format = "{audio}{current_title}";
    #         format_pinned = "{audio}";
    #       };
    #     };
    #     url = {
    #       auto_search = "dns";
    #       default_page = "about:blank";
    #       incdec_segments = [ "path" "query" ];
    #       yank_ignored_parameters = [ "ref" "utm_source" "utm_medium" "utm_campaign" "utm_term" "utm_content" ];
    #       start_pages = [ "about:blank" ];
    #     };
    #     window.title_format = "{private}{perc}{current_title}{title_sep}qutebrowser | {current_url}";
    #   };
    #   searchEngines = {
    #     DEFAULT = "https://www.google.com/search?q={}";
    #     d = "https://duckduckgo.com/?q={}";
    #     n = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&query={}";
    #     y = "https://www.youtube.com/results?search_query={}";
    #     w = "https://www.merriam-webster.com/dictionary/{}";
    #   };
    #   keyBindings = {
    #     normal = {
    #       "<space>tt" = "config-cycle tabs.show multiple never";
    #       "<space>bb" = "bookmark-list";
    #       "<space>bn" = "set-cmd-text -s :quickmark-add {url}";
    #       "<space>bd" = "quickmark-del";
    #       "<space>C" = "clear-messages";
    #       "<space>dd" = "download";
    #       "<space>dc" = "download-cancel";
    #       "<space>dC" = "download-clear";
    #       "<space>dr" = "download-retry";
    #       "<space>gm" = "open https://mail.google.com";
    #       "<space>gc" = "open https://calendar.google.com";
    #       "<space>gy" = "open https://youtube.com";
    #       "<space>gg" = "open https://google.com";
    #       "<Ctrl-e>" = "scroll-px 0 20";
    #       "<Ctrl-y>" = "scroll-px 0 -20";
    #       "<space>ss" = "set-cmd-text -s :session-save -o ";
    #       "<space>so" = "set-cmd-text -s :session-load -t";
    #       "<space>sd" = "set-cmd-text -s :session-delete ";
    #       "<Ctrl-1>" = "tab-focus 1";
    #       "<Ctrl-2>" = "tab-focus 2";
    #       "<Ctrl-3>" = "tab-focus 3";
    #       "<Ctrl-4>" = "tab-focus 4";
    #       "<Ctrl-5>" = "tab-focus 5";
    #       "<Ctrl-6>" = "tab-focus 6";
    #       "<Ctrl-7>" = "tab-focus 7";
    #       "<Ctrl-8>" = "tab-focus 8";
    #       "<Ctrl-9>" = "tab-focus 9";
    #       "<Ctrl-m>" = "tab-mute";
    #       "wc" = "close";
    #       "wq" = "close";
    #       "to" = "tab-only";
    #       "gT" = "set-cmd-text -s :tab-take";
    #       "si" = "set -u *://{url:host}/* content.tls.certificate_errors load-insecurely";
    #       "sI" = "set -u *://{url:host}/* content.tls.certificate_errors block";
    #       "<space>pr" = "proxym";
    #       "<space>ps" = "noproxym";
    #       "<space>pm" = "spawn mitmproxy-local-start";
    #       "<space>pM" = "spawn mitmproxy-local-stop";
    #       "yd" = "yank inline {url:host}";
    #       "yD" = "yank inline {url:host} -s";
    #       "gB" = "tab-give";
    #       "gj" = "tab-move +";
    #       "gk" = "tab-move -";
    #       "dd" = "tab-close";
    #       "rr" = "reload";
    #       "wv" = "spawn vlc {url}";
    #       "pw" = "spawn --userscript qute_1pass --cache-session fill_credentials";
    #     };
    #     insert = {
    #       "<Ctrl-y>" = "insert-text -- {clipboard}";
    #       "<Alt-Shift-u>" = "spawn --userscript qute_1pass --cache-session fill_username";
    #       "<Alt-Shift-p>" = "spawn --userscript qute_1pass --cache-session fill_password";
    #       "<Alt-Shift-t>" = "spawn ykman-otp";
    #       # "<Alt-Shift-t>" = "spawn --userscript qute_1pass --cache-session fill_totp";
    #     };
    #     command = {
    #       "<Ctrl-j>" = "completion-item-focus --history next";
    #       "<Ctrl-k>" = "completion-item-focus --history prev";
    #       "<Ctrl-m>" = "command-accept";
    #     };
    #   };
    #   extraConfig = ''
    #     config.unbind('d', mode='normal')
    #     config.unbind('r', mode='normal')
    #     config.set('content.javascript.enabled', True, 'chrome://*/*')
    #     config.set('content.javascript.enabled', True, 'file://*')
    #     config.set('content.javascript.enabled', True, 'qute://*/*')
    #     config.load_autoconfig(False)
    #     c.bindings.key_mappings = {
    #         'Й': 'Q', 'й': 'q',
    #         'Ц': 'W', 'ц': 'w',
    #         'У': 'E', 'у': 'e',
    #         'К': 'R', 'к': 'r',
    #         'Е': 'T', 'е': 't',
    #         'Н': 'Y', 'н': 'y',
    #         'Г': 'U', 'г': 'u',
    #         'Ш': 'I', 'ш': 'i',
    #         'Щ': 'O', 'щ': 'o',
    #         'З': 'P', 'з': 'p',
    #         'Х': '{', 'х': '[',
    #         'Ъ': '}', 'ъ': ']',
    #         'Ф': 'A', 'ф': 'a',
    #         'Ы': 'S', 'ы': 's',
    #         'В': 'D', 'в': 'd',
    #         'А': 'F', 'а': 'f',
    #         'П': 'G', 'п': 'g',
    #         'Р': 'H', 'р': 'h',
    #         'О': 'J', 'о': 'j',
    #         'Л': 'K', 'л': 'k',
    #         'Д': 'L', 'д': 'l',
    #         'Ж': ':', 'ж': ';',
    #         'Э': '"', 'э': '\''',
    #         'Я': 'Z', 'я': 'z',
    #         'Ч': 'X', 'ч': 'x',
    #         'С': 'C', 'с': 'c',
    #         'М': 'V', 'м': 'v',
    #         'И': 'B', 'и': 'b',
    #         'Т': 'N', 'т': 'n',
    #         'Ь': 'M', 'ь': 'm',
    #         'Б': '<', 'б': ',',
    #         'Ю': '>', 'ю': '.',
    #         ',': '?', '.': '/',
    #     }
    #     ${replaceStrings [
    #     "base00 ="
    #     "base01 ="
    #     "base02 ="
    #     "base03 ="
    #     "base04 ="
    #     "base05 ="
    #     "base06 ="
    #     "base07 ="
    #     "base08 ="
    #     "base09 ="
    #     "base0A ="
    #     "base0B ="
    #     "base0C ="
    #     "base0D ="
    #     "base0E ="
    #     "base0F ="
    #   ] [
    #     ''base00 = "#${colors.color0}"''
    #     ''base01 = "#${colors.color10}"''
    #     ''base02 = "#${colors.color11}"''
    #     ''base03 = "#${colors.color8}"''
    #     ''base04 = "#${colors.color12}"''
    #     ''base05 = "#${colors.color7}"''
    #     ''base06 = "#${colors.color13}"''
    #     ''base07 = "#${colors.color15}"''
    #     ''base08 = "#${colors.color1}"''
    #     ''base09 = "#${colors.color9}"''
    #     ''base0A = "#${colors.color3}"''
    #     ''base0B = "#${colors.color2}"''
    #     ''base0C = "#${colors.color6}"''
    #     ''base0D = "#${colors.color4}"''
    #     ''base0E = "#${colors.color5}"''
    #     ''base0F = "#${colors.color14}"''
    #   ]
    #     (readFile ./config/qutebrowser.py)}
    #   '';
    # };

    # xdg.configFile."qutebrowser/userscripts/qute_1pass" = {
    #   source = ./config/qute-1pass.py;
    #   executable = true;
    # };

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
}
