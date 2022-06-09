{ config, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.opt.security;

  ykmanOtp = pkgs.writeShellScriptBin "ykman-otp" ''
    set -euo pipefail

    PASS=""
    if [ ! "$(ykman info)" ]
    then
        rofi_run -dmenu -mesg "Yubikey not detected." -a "rofi-ykman"
        exit 1
    else
        PASS_ENABLED=$(ykman oath info | grep "Password protection" | awk '{print $3}')
        PASS_REMEMBERED=$(ykman oath info | grep -q "The password for this YubiKey is remembered by ykman.";echo $?)
        if [ "$PASS_ENABLED" == "enabled" ]
        then
            if [ "$PASS_REMEMBERED" == "1" ]
            then
              PASS="-p $(rofi_run -password -dmenu -p 'Vault Password' -l 0 -sidebar -width 20)"
            fi
        fi
    fi

    OPTIONS=$(ykman oath accounts list $PASS)
    LAUNCHER="rofi_run -dmenu -i -p YubikeyOATH"

    option=`echo "''${OPTIONS/, TOTP/\n}" | $LAUNCHER`
    code=$(ykman oath accounts code $PASS "$option")
    IFS=', ' read -r -a code <<< "$code"
    echo "''${code[-1]}" | xclip -selection clipboard

    ${pkgs.libnotify}/bin/notify-send -t 5000 "''${code[-1]}"
  '';

  yubikeyReset = pkgs.writeShellScriptBin "yubikey-reset" ''
    prompt=$(sudo -nv 2>&1)
    if [ $? -eq 0 ]; then
      echo "Sudo priveleges available."
    elif echo $prompt | grep -q '^sudo:'; then
      echo "$(rofi_run -password -dmenu -p 'Sudo password' -l 0 -sidebar -width 20)" | sudo -S echo "Granted"
    else
      rofi_run -dmenu -mesg "You don't have sudo priveleges." -a "rofi-ykman"
      exit 1
    fi

    set -euo pipefail
    IFS=$'\n\t'

    VENDOR="1050"
    PRODUCT="0407"

    for DIR in $(find /sys/bus/usb/devices/ -maxdepth 1 -type l); do
      if [[ -f $DIR/idVendor && -f $DIR/idProduct &&
            $(${pkgs.coreutils}/bin/cat $DIR/idVendor) == $VENDOR && $(${pkgs.coreutils}/bin/cat $DIR/idProduct) == $PRODUCT ]]; then
        echo 0 | sudo tee -a $DIR/authorized
        sleep 0.5
        echo 1 | sudo tee -a $DIR/authorized
      fi
    done

    ${pkgs.libnotify}/bin/notify-send -t 5000 "Reset"
  '';

  opSession = pkgs.writeShellScriptBin "op-session" ''
    set -e
    if [ "$1" == "signin" ]; then
      ${pkgs._1password}/bin/op $*
    elif [ "$1" == "refresh" ]; then
      ${pkgs.coreutils}/bin/touch ~/.cache/op-session
      export OP_SESSION_my=$(cat ~/.cache/op-session)
      if ! ${pkgs._1password}/bin/op account get &> /dev/null; then
        echo "Session is not initialized."
      else
        echo "Session is refreshed."
      fi
    else
      ${pkgs.coreutils}/bin/touch ~/.cache/op-session
      export OP_SESSION_my=$(${pkgs.coreutils}/bin/cat ~/.cache/op-session)
      if ! op account get &> /dev/null; then
        ${pkgs.pinentry}/bin/pinentry << EOS | ${pkgs.gnugrep}/bin/grep -oP 'D \K.*' | ${pkgs._1password}/bin/op signin --raw > ~/.cache/op-session
    SETDESC Enter your 1password master password:
    SETPROMPT Master Password:
    GETPIN
    EOS
        export OP_SESSION_my=$(${pkgs.coreutils}/bin/cat ~/.cache/op-session)
      fi
      ${pkgs._1password}/bin/op $*
    fi
  '';
in
  {
    options.opt.security = {
      enable = mkOption { type = types.bool; };
      username = mkOption { type = types.str; };
      keybase.enable = mkOption {type = types.bool;};
      veracrypt.enable = mkOption { type = types.bool; };
      enpass.enable = mkOption { type = types.bool; };
      keepass.enable = mkOption { type = types.bool; };
      lastpass.enable = mkOption { type = types.bool; };
      onep.enable = mkOption { type = types.bool; };
      yubikey.enable = mkOption { type = types.bool; };
      cryptomator.enable = mkOption { type = types.bool; };
    };

    config = mkMerge [
      (mkIf cfg.enable {

        services.gnome.gnome-keyring.enable = true;
        programs.seahorse.enable = true;
        security.pam.services.lightdm.enableGnomeKeyring = true;

        environment.systemPackages = with pkgs; [
          gnupg
        ];
        services.pcscd.enable = true;

        home-manager.users.${cfg.username} = {

          services.keybase.enable = cfg.keybase.enable;
          services.kbfs.enable = cfg.keybase.enable;

          home.packages = [
            pkgs.xclip
            pkgs.gnupg

            pkgs.pinentry
          ] ++
          optionals (cfg.cryptomator.enable) [
            pkgs.cryptomator
          ] ++
          optionals (cfg.keybase.enable) [
            pkgs.keybase-gui
          ] ++
          optionals (cfg.veracrypt.enable) [
            pkgs.veracrypt
          ] ++
          optionals (cfg.enpass.enable) [
            pkgs.enpass
          ] ++
          optionals (cfg.keepass.enable) [
            pkgs.keepassxc
          ] ++
          optionals (cfg.lastpass.enable) [
            pkgs.lastpass-cli
          ] ++
          optionals (cfg.yubikey.enable) [
            pkgs.yubikey-manager
            pkgs.yubikey-manager-qt
            pkgs.yubikey-personalization-gui
            pkgs.yubico-pam
            pkgs.yubikey-agent
            pkgs.yubioath-desktop
            ykmanOtp
            yubikeyReset
          ];
        };
      })
      (mkIf (cfg.enable && cfg.onep.enable) {
        home-manager.users.${cfg.username} = {
          home.packages = [
            pkgs._1password
            pkgs._1password-gui
            opSession
          ];

          systemd.user.services.op-ping = {
            Unit = {
              Description = "OP pinger";
              After = [ "graphical-session-pre.target" ];
              PartOf = [ "graphical-session.target" ];
            };
            Service = {
              CPUSchedulingPolicy = "idle";
              IOSchedulingClass = "idle";
              ExecStart =  "${opSession}/bin/op-session";
            };
          };
          systemd.user.timers.op-ping = {
            Unit = { Description = "Run op ping"; };
            Timer = {
              Unit = "op-ping.service";
              OnCalendar = "*:0/20";
              Persistent = true;
            };
            Install = { WantedBy = [ "timers.target" ]; };
          };
        };
      })
    ];
  }
