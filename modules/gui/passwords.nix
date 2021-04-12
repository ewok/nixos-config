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

    home-manager.users.${username} = {
      home.packages = [
        pkgs.enpass-my
        master.keepassxc
      ];

      xdg.configFile."keepassxc/keepassxc.ini".text = ''
        [General]
        BackupBeforeSave=true
        ConfigVersion=1
        GlobalAutoTypeKey=63
        GlobalAutoTypeModifiers=100663296
        MinimizeAfterUnlock=true

        [Browser]
        CustomProxyLocation=
        Enabled=false

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
