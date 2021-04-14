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
    ${pkgs.rofi}/bin/rofi -icon-theme "Papirus" -show-icons -theme base16-onedark -terminal ${pkgs.alacritty}/bin/alacritty $@
  '';

  rofiBluetoothThemed = pkgs.writeShellScriptBin "rofi-bluetooth" ''
    ROFI_THEME=base16-onedark ${pkgs.rofi-bluetooth}/bin/rofi-bluetooth $@
  '';

  todofishCustom = pkgs.writeShellScriptBin "todofi.sh" ''
    export TODOFI_SHORTCUT_NEW="Shift+space"
    export TODOFI_CMD_DO="again"
    export TODO_NO_AGAIN_IF_NOT_TAGGED=1
    ${pkgs.todofish}/bin/todofi.sh $@
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

      # Does not work yet
      xdg.configFile."rofi/base16-onedark.rasi".text = ''
        * {
            red:                         rgba ( 224, 108, 117, 100 % );
            blue:                        rgba ( 97, 175, 239, 100 % );
            lightfg:                     rgba ( 182, 189, 202, 100 % );
            lightbg:                     rgba ( 53, 59, 69, 100 % );
            foreground:                  rgba ( 171, 178, 191, 100 % );
            background:                  rgba ( 40, 44, 52, 100 % );
            background-color:            rgba ( 40, 44, 52, 0 % );
            separatorcolor:              @foreground;
            border-color:                @foreground;
            selected-normal-foreground:  @lightbg;
            selected-normal-background:  @lightfg;
            selected-active-foreground:  @background;
            selected-active-background:  @blue;
            selected-urgent-foreground:  @background;
            selected-urgent-background:  @red;
            normal-foreground:           @foreground;
            normal-background:           @background;
            active-foreground:           @blue;
            active-background:           @background;
            urgent-foreground:           @red;
            urgent-background:           @background;
            alternate-normal-foreground: @foreground;
            alternate-normal-background: @lightbg;
            alternate-active-foreground: @blue;
            alternate-active-background: @lightbg;
            alternate-urgent-foreground: @red;
            alternate-urgent-background: @lightbg;
        }
      '';

      xresources.extraConfig = ''
        ! Base16 OneDark
        ! Author: Lalit Magant (http://github.com/tilal6991)
        ! base00: #282c34
        ! base01: #353b45
        ! base02: #3e4451
        ! base03: #545862
        ! base04: #565c64
        ! base05: #abb2bf
        ! base06: #b6bdca
        ! base07: #c8ccd4
        ! base08: #e06c75
        ! base09: #d19a66
        ! base0A: #e5c07b
        ! base0B: #98c379
        ! base0C: #56b6c2
        ! base0D: #61afef
        ! base0E: #c678dd
        ! base0F: #be5046
        ! Enable the extended coloring options
        rofi.color-enabled: true
        ! Property Name     BG       Border   Separator
        rofi.color-window:  #353b45, #353b45, #282c34
        ! Property Name     BG       FG       BG-alt   Head-BG  Head-FG
        rofi.color-normal:  #353b45, #abb2bf, #353b45, #e5c07b, #3e4451
        rofi.color-active:  #353b45, #61afef, #353b45, #e5c07b, #61afef
        rofi.color-urgent:  #353b45, #e06c75, #353b45, #e5c07b, #e06c75
        ! Set the desired separator style
        rofi.separator-style: solid
      '';
    };
  };
}
