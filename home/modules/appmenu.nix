{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.home.gui;
  colors = config.home.theme.colors;
  terminal = config.home.terminal;

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
    ${pkgs.rofi}/bin/rofi -icon-theme "Papirus" -show-icons -terminal ${terminal} $@
  '';

  #rofiBluetoothThemed = pkgs.writeShellScriptBin "rofi-bluetooth" ''
  #  #ROFI_THEME=base16-onedark ${pkgs.rofi-bluetooth}/bin/rofi-bluetooth $@
  #  ${pkgs.rofi-bluetooth}/bin/rofi-bluetooth $@
  #'';

  todofishCustom = pkgs.writeShellScriptBin "todofi.sh" ''
    export TODOFI_SHORTCUT_NEW="Shift+space"
    export TODOFI_CMD_DO="again"
    export TODO_NO_AGAIN_IF_NOT_TAGGED=1
    ${pkgs.todofish}/bin/todofi.sh $@
  '';

in
{
  config = mkIf gui.enable {
    home.packages = with pkgs; [
      bc
      dmcalc
      dmkill
      dmmyip
      dmprompt
      rofi
      rofi_run
      todofishCustom
      # rofiBluetoothThemed
      rofi-bluetooth
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
      ! base00: #${colors.color0}
      ! base01: #${colors.color10}
      ! base02: #${colors.color11}
      ! base03: #${colors.color8}
      ! base04: #${colors.color12}
      ! base05: #${colors.color7}
      ! base06: #${colors.color13}
      ! base07: #${colors.color15}
      ! base08: #${colors.color1}
      ! base09: #${colors.color9}
      ! base0A: #${colors.color3}
      ! base0B: #${colors.color2}
      ! base0C: #${colors.color6}
      ! base0D: #${colors.color4}
      ! base0E: #${colors.color5}
      ! base0F: #${colors.color14}
      ! Enable the extended coloring options
      rofi.color-enabled: true
      ! Property Name     BG       Border   Separator
      rofi.color-window:  #${colors.color10}, #${colors.color10}, #${colors.color0}
      ! Property Name     BG       FG       BG-alt   Head-BG  Head-FG
      rofi.color-normal:  #${colors.color10}, #${colors.color7}, #${colors.color10}, #${colors.color3}, #${colors.color11}
      rofi.color-active:  #${colors.color10}, #${colors.color4}, #${colors.color10}, #${colors.color3}, #${colors.color4}
      rofi.color-urgent:  #${colors.color10}, #${colors.color1}, #${colors.color10}, #${colors.color3}, #${colors.color1}
      ! Set the desired separator style
      rofi.separator-style: solid
    '';
  };
}
