{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
in
  {
    config = mkIf gui.enable {
      environment.sessionVariables = { BROWSER = "qutebrowser"; };

      home-manager.users.${username} = {
        home.packages = with pkgs; [
          xsel

          (makeDesktopItem {
            name = "org.custom.qutebrowser.windowed";
            type = "Application";
            exec = "qutebrowser --target window %U";
            comment = "Qutebrowser that opens links preferably in new windows";
            desktopName = "QuteBrowser";
            categories = lib.concatStringsSep ";" [ "Network" "WebBrowser" ];
          })
        ];

        programs.firefox = {
          enable = true;
          profiles = {
            options = {
              name = "${username}";
              id = 0;
              settings = {
                "browser.startup.homepage" = "about:blank";
                "browser.search.region" = "RU";
                "browser.search.isUS" = true;
                "browser.bookmarks.showMobileBookmarks" = true;
                "browser.bookmarks.restore_default_bookmarks" = false;
                "browser.cache.disk.parent_directory" = "/tmp/firefox";
                "browser.tabs.warnOnClose" = false;
                "browser.urlbar.suggest.history" = false;
                "browser.urlbar.suggest.searches" = false;
                "extensions.pocket.enabled" = false;
                "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
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
          };
          settings = {
            auto_save = {
              interval = 15000;
              session = true;
            };
            # editor.command = [
            #   "${config.ide.emacs.core.package}/bin/emacsclient"
            #   "-c"
            #   "-s /run/user/${builtins.toString config.users.extraUsers."${user}".uid}/emacs/server"
            #   "+{line}:{column}"
            #   "{}"
            # ];
            zoom.levels = [
              "25%"
              "33%"
              "50%"
              "67%"
              "75%"
              "90%"
              "100%"
              "110%"
              "125%"
              "150%"
              "175%"
              "200%"
              "250%"
              "300%"
              "400%"
              "500%"
            ];
            colors = {
              statusbar.url.success.https.fg = "white";
              tabs = rec {
                even.bg = "#49505E";
                even.fg = "#639EE4";
                odd.bg = "#35383F";
                odd.fg = even.fg;
                bar.bg = "#282C34";
              };
              webpage = {
                prefers_color_scheme_dark = true;
                bg = "#282C34";
                darkmode.enabled = true;
                darkmode.policy.images = "never";
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
              notifications = true;
              pdfjs = true;
              plugins = true;
              proxy = "none";
              register_protocol_handler = true;
              ssl_strict = true;
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
            # hints = {
            #   hide_unmatched_rapid_hints = true;
            #   leave_on_load = true;
            #   min_chars = 1;
            #   mode = "number";
            #   next_regexes = [
            #     "\\\\bnext\\\\b"
            #     "\\\\bmore\\\\b"
            #     "\\\\bnewer\\\\b"
            #     "\\\\b[>→≫]\\\\b"
            #     "\\\\b(>>|»)\\\\b"
            #     "\\\\bcontinue\\\\b"
            #   ];
            #   prev_regexes =
            #     [ "\\\\bprev(ious)?\\\\b" "\\\\bback\\\\b" "\\\\bolder\\\\b" "\\\\b[<←≪]\\\\b" "\\\\b(<<|«)\\\\b" ];
            #     scatter = false;
            #     uppercase = false;
            #   };
              history_gap_interval = 30;
              input = {
                insert_mode = {
                  auto_leave = true;
                  auto_load = false;
                  plugins = false;
                };
                links_included_in_focus_chain = true;
                partial_timeout = 2000;
                spatial_navigation = true;
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
              session.lazy_restore = false;
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
              start_pages = [ "https://google.com" ];
            };
            window.title_format = "{private}{perc}{current_title}{title_sep}qutebrowser | {current_url}";
          };
          searchEngines = {
            DEFAULT =  "https://www.google.com/search?q={}";
            d =  "https://duckduckgo.com/?q={}";
            n = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&query={}";
          };
          # keyMappings = {
          #   "<space>пп" = "<space>gg";
          # };
          keyBindings = {
            normal = {
              "<space>tt" = "config-cycle tabs.show multiple never";
              "<space>tc" = "tab-clone";
              "<space>bb" = "quickmark-save";
              "<space>bl" = "bookmark-list";
              "<space>bd" = "quickmark-del";
              "<space>C" = "clear-messages";
              "<space>dd" = "download";
              "<space>dc" = "download-cancel";
              "<space>dC" = "download-clear";
              "<space>dr" = "download-retry";
              "<space>gm" = "open https://mail.google.com";
              "<space>gy" = "open https://youtube.com";
              "<space>gg" = "open https://google.com";
              "<Ctrl-e>" = "scroll-px 0 20";
              "<Ctrl-y>" = "scroll-px 0 -20";
              "<space>ss" = "set-cmd-text -s :session-save";
              "<space>so" = "set-cmd-text -s :session-load ";
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
            };
            insert = {
              "<Ctrl-y>" = "insert-text -- {clipboard}";
              "<Shift-y>" = "insert-text -- {primary}";
            };
            command = {
              "<Ctrl-j>" = "completion-item-focus --history next";
              "<Ctrl-k>" = "completion-item-focus --history prev";
            };
          };
          extraConfig = ''
            config.set('content.javascript.enabled', True, 'chrome://*/*')
            config.set('content.javascript.enabled', True, 'file://*')
            config.set('content.javascript.enabled', True, 'qute://*/*')
            config.load_autoconfig(False)
          '';
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
          "x-scheme-handler/unknown"] (_: [ "org.custom.qutebrowser.windowed.desktop" ]);

        };
      };
    }
