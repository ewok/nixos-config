{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;

  ykmanOtp = pkgs.writeShellScriptBin "ykman-otp" ''
    set -euo pipefail
    sudo ${yubikeyReset}/bin/yubikey-reset
    PASS=""

    if [ ! "$(ykman info)" ]
    then
        rofi -dmenu -mesg "Yubikey not detected." -a "rofi-ykman"
        exit 1
    else
        PASS_ENABLED=$(ykman oath info | grep "Password protection" | awk '{print $3}')
        if [ "$PASS_ENABLED" == "enabled" ]
        then
            PASS="-p $(rofi -password -dmenu -p 'Vault Password' -l 0 -sidebar -width 20)"
        fi
    fi


    OPTIONS=$(ykman oath accounts list $PASS)
    LAUNCHER="rofi -dmenu -i -p YubikeyOATH"

    option=`echo "''${OPTIONS/, TOTP/\n}" | $LAUNCHER`
    code=$(ykman oath accounts code $PASS "$option")
    IFS=', ' read -r -a code <<< "$code"
    echo "''${code[-1]}" | xclip -selection clipboard
  '';

  yubikeyReset = pkgs.writeShellScriptBin "yubikey-reset" ''
    set -euo pipefail
    IFS=$'\n\t'

    VENDOR="1050"
    PRODUCT="0407"

    for DIR in $(find /sys/bus/usb/devices/ -maxdepth 1 -type l); do
      if [[ -f $DIR/idVendor && -f $DIR/idProduct &&
            $(${pkgs.coreutils}/bin/cat $DIR/idVendor) == $VENDOR && $(${pkgs.coreutils}/bin/cat $DIR/idProduct) == $PRODUCT ]]; then
        echo 0 | tee -a $DIR/authorized
        sleep 0.5
        echo 1 | tee -a $DIR/authorized
      fi
    done
  '';

  opSession = pkgs.writeShellScriptBin "op-session" ''
    ${pkgs.coreutils}/bin/mkdir -p /tmp/qute_1pass

    export OP_SESSION_my=$(${pkgs.coreutils}/bin/cat /tmp/qute_1pass/session)

    if [ "$1" == "signin" ]; then
      ${pkgs._1password}/bin/op $*
    else
      if ! ${pkgs._1password}/bin/op get account &> /dev/null; then
        export OP_SESSION_my=$(${pkgs._1password}/bin/op signin my --raw)
        echo $OP_SESSION_my > /tmp/qute_1pass/session
      fi
      ${pkgs._1password}/bin/op $*
    fi

  '';

in
{
  config = mkIf gui.enable {

    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;
    security.pam.services.lightdm.enableGnomeKeyring = true;

    environment.systemPackages = with pkgs; [
      gnupg
    ];
    services.pcscd.enable = true;

    # Run yubikey-reset without password
    security.sudo.extraRules = [
      {
        users = [ username ];
        commands = [ { command = "${yubikeyReset}/bin/yubikey-reset"; options = [ "SETENV" "NOPASSWD" ]; } ];
      }
      {
        users = [ username ];
        commands = [ { command = "/home/${username}/.nix-profile/bin/yubikey-reset"; options = [ "SETENV" "NOPASSWD" ]; } ];
      }
    ];

    home-manager.users.${username} = {

      services.keybase.enable = true;
      services.kbfs.enable = true;

      home.packages = [
        pkgs.keybase-gui

        pkgs.enpass
        pkgs.keepassxc
        pkgs.pinentry

        pkgs.lastpass-cli

        pkgs._1password
        pkgs._1password-gui
        opSession

        pkgs.yubikey-manager
        pkgs.yubikey-manager-qt
        pkgs.yubikey-personalization-gui
        pkgs.yubico-pam
        pkgs.yubikey-agent
        pkgs.yubioath-desktop
        ykmanOtp

        yubikeyReset

        pkgs.veracrypt
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
        defaultCacheTtl = 34560000;
        maxCacheTtl = 34560000;
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


      # Ping op
      systemd.user.services.ping-op = {
        Unit = { Description = "Ping op"; };

        Service = {
          CPUSchedulingPolicy = "idle";
          IOSchedulingClass = "idle";
          ExecStart = toString (
            pkgs.writeShellScript "ping-op" ''
              set -e
              if ${opSession}/bin/op-session get account;then
                ${pkgs.coreutils}/bin/touch /tmp/qute_1pass/session
              else
                ${pkgs.coreutils}/bin/rm -f /tmp/qute_1pass/session
              fi
            ''
          );
        };
      };

      systemd.user.timers.ping-op = {
        Unit = { Description = "Ping op"; };

        Timer = {
          Unit = "ping-op.service";
          OnCalendar = "*:0/20";
          Persistent = true;
        };

        Install = { WantedBy = [ "timers.target" ]; };
      };

    };
  };
}
