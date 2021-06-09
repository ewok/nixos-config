{ config, lib, inputs, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
  master = import inputs.master (
    {
      config = config.nixpkgs.config;
      localSystem = { system = "x86_64-linux"; };
    }
  );
in
{
  config = mkIf gui.enable {

    services.gnome3.gnome-keyring.enable = true;
    programs.seahorse.enable = true;
    security.pam.services.lightdm.enableGnomeKeyring = true;

    environment.systemPackages = with pkgs; [
      gnupg
    ];
    services.pcscd.enable = true;

    home-manager.users.${username} = {
      home.packages = [
        pkgs.enpass
        master.keepassxc
        pkgs.pinentry

        pkgs.lastpass-cli

        master._1password
        master._1password-gui

        master.yubikey-manager
        master.yubikey-manager-qt
        master.yubikey-personalization-gui
        pkgs.yubico-pam
        pkgs.yubikey-agent
        pkgs.yubioath-desktop

        (pkgs.writeShellScriptBin "yubikey-reset" ''
          set -euo pipefail
          IFS=$'\n\t'

          VENDOR="1050"
          PRODUCT="0407"

          for DIR in $(find /sys/bus/usb/devices/ -maxdepth 1 -type l); do
            if [[ -f $DIR/idVendor && -f $DIR/idProduct &&
                  $(cat $DIR/idVendor) == $VENDOR && $(cat $DIR/idProduct) == $PRODUCT ]]; then
              echo 0 | sudo tee -a $DIR/authorized
              sleep 0.5
              echo 1 | sudo tee -a $DIR/authorized
            fi
          done
        '')

      ];

      programs.gpg = {
        enable = true;
        scdaemonSettings = {
          disable-ccid = true;
          reader-port = "Yubico Yubi";
        };

      };
      services.gpg-agent = {
        enable = true;
        defaultCacheTtl = 7200;
        maxCacheTtl = 86400;
        enableSshSupport = true;
      };

      xdg.configFile."keepassxc/keepassxc.ini".text = ''
        [General]
        BackupBeforeSave=true
        ConfigVersion=1
        GlobalAutoTypeKey=63
        GlobalAutoTypeModifiers=100663296
        MinimizeAfterUnlock=true

        [Browser]
        CustomProxyLocation=
        Enabled=true

        [GUI]
        ApplicationTheme=dark
        CompactMode=false
        HidePasswords=true
        MinimizeOnClose=true
        MinimizeOnStartup=false
        MinimizeToTray=true
        ShowTrayIcon=true
        TrayIconAppearance=monochrome-light

        [KeeShare]
        Active="<?xml version=\"1.0\"?>\n<KeeShare xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n  <Active/>\n</KeeShare>\n"
        Foreign="<?xml version=\"1.0\"?>\n<KeeShare xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n  <Foreign/>\n</KeeShare>\n"
        Own="<?xml version=\"1.0\"?>\n<KeeShare xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n  <PrivateKey/>\n  <PublicKey/>\n</KeeShare>\n"
        QuietSuccess=true

        [PasswordGenerator]
        AdditionalChars=
        ExcludedChars=
        Logograms=true
      '';
    };
  };
}
