{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;

  dmprompt = pkgs.writeShellScriptBin "dmprompt" ''
    [ "$(printf 'No\nYes' \
        | ${rofi_run}/bin/rofi_run -dmenu -p "$1" \
        -i -nb darkred -sb red -sf black -nf gray)" = 'Yes' ] && $2
  '';

  dmcalc = pkgs.writeShellScriptBin "calc" ''
    dmenucmd="${rofi_run}/bin/rofi_run -dmenu -p Calc $@"

    while : ; do
        result=$(${pkgs.xsel}/bin/xsel -o -b | $dmenucmd | xargs echo | ${pkgs.bc}/bin/bc -l 2>&1)
        if [[ $result ]]; then
            printf "$result" | ${pkgs.xsel}/bin/xsel -b
        fi
        [[ $result ]] || break
    done
  '';

  dmkill = pkgs.writeShellScriptBin "dmkill" ''
    export selected_k="$(ps --user "$(id -u)" -F | \
                ${rofi_run}/bin/rofi_run -dmenu -i -l 20 -p "Search for process to kill:" | \
                awk '{print $2" "$11}')";

    if [[ -n $selected_k ]]; then

        dmprompt "Kill $selected_k?" ${pkgs.writeShellScript "dmkill_helper" ''
            selpid="$(awk '{print $1}' <<< $selected_k)";
            kill -9 $selpid
            echo "Process $selected_k has been killed." && exit 1
          ''}
    fi
    '';

  dmmyip = pkgs.writeShellScriptBin "myip" ''
    dmenucmd="${rofi_run}/bin/rofi_run -dmenu -p MyIP: $@"

    while : ; do
        result=$(${pkgs.curl}/bin/curl ifconfig.me | $dmenucmd)
        if [[ $result ]]; then
            printf "$result" | ${pkgs.xsel}/bin/xsel -b
        fi
        [[ $result ]] || break
    done

  '';

  rofi_run = pkgs.writeShellScriptBin "rofi_run" ''
    ${pkgs.rofi}/bin/rofi -icon-theme "Papirus" -show-icons -theme android_notification -terminal ${pkgs.kitty}/bin/kitty $@
  '';

  rofiBluetoothThemed = pkgs.writeShellScriptBin "rofi-bluetooth" ''
    ROFI_THEME=android_notification ${pkgs.rofi-bluetooth}/bin/rofi-bluetooth $@
  '';

  todofishCustom = pkgs.writeShellScriptBin "todofi.sh" ''
    TODOFI_SHORTCUT_NEW="Shift+space" ${pkgs.todofish}/bin/todofi.sh $@
  '';

in
  {
    config = mkIf gui.enable {
      home-manager.users.${username} = {
        home.packages = with pkgs; [
          bc
          dmcalc
          dmkill
          dmmyip
          dmprompt
          rofi
          rofi_run
          todofishCustom
          rofiBluetoothThemed
        ];
      };
    };
  }
