{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
in
  {
    config = mkIf gui.enable {
      home-manager.users.${username} = {
        home.packages = with pkgs; [
          albert
        ];

        xdg.configFile."albert/albert.conf".text = ''
          [General]
          frontendId=org.albert.frontend.widgetboxmodel
          hotkey=Ctrl+Shift+Alt+D
          showTray=true
          telemetry=false
          terminal=kitty

          [org.albert.extension.applications]
          enabled=true
          fuzzy=true
          ignore_show_in_keys=false
          use_generic_name=false
          use_keywords=false
          use_non_localized_name=false

          [org.albert.extension.calculator]
          enabled=true

          [org.albert.extension.chromebookmarks]
          enabled=false

          [org.albert.extension.externalextensions]
          enabled=false

          [org.albert.extension.files]
          enabled=false
          paths=@Invalid()

          [org.albert.extension.firefoxbookmarks]
          enabled=false
          fuzzy=true
          openWithFirefox=true

          [org.albert.extension.hashgenerator]
          enabled=true

          [org.albert.extension.mpris]
          enabled=false

          [org.albert.extension.python]
          enabled=true
          enabled_modules=ip, currency_converter, pass, zeal

          [org.albert.extension.snippets]
          enabled=false

          [org.albert.extension.ssh]
          enabled=false

          [org.albert.extension.system]
          enabled=false

          [org.albert.extension.terminal]
          enabled=true

          [org.albert.extension.virtualbox]
          enabled=false

          [org.albert.extension.websearch]
          enabled=false

          [org.albert.frontend.qmlboxmodel]
          alwaysOnTop=true
          clearOnHide=false
          hideOnClose=false
          hideOnFocusLoss=true
          showCentered=true
          stylePath=/usr/share/albert/org.albert.frontend.qmlboxmodel/styles/BoxModel/MainComponent.qml
          windowPosition=@Point(610 284)

          [org.albert.frontend.widgetboxmodel]
          alwaysOnTop=false
          clearOnHide=true
          displayIcons=true
          displayScrollbar=false
          displayShadow=false
          hideOnClose=true
          hideOnFocusLoss=false
          itemCount=10
          showCentered=false
          theme=Adapta
        '';
      };
    };
  }
