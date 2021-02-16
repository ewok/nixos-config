{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
in
  {
    config = mkIf gui.enable {
      environment.sessionVariables = { BROWSER = "firefox"; };

      home-manager.users.${username} = {
        home.packages = with pkgs; [
          xsel
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
      };
    };
  }
