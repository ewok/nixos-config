#/usr/bin/bash

case $1 in
    2)
    swaymsg output eDP-1 transform 270
    # waydroid prop set persist.waydroid.height "800"
    # waydroid prop set persist.waydroid.width "1280"
        ;;
    3)
    swaymsg output eDP-1 transform 90
    # waydroid prop set persist.waydroid.height "800"
    # waydroid prop set persist.waydroid.width "1280"
        ;;
    1)
    swaymsg output eDP-1 transform 0
    # waydroid prop set persist.waydroid.height "1280"
    # waydroid prop set persist.waydroid.width "800"
        ;;
    4)
    swaymsg output eDP-1 transform 180
    # waydroid prop set persist.waydroid.height "1280"
    # waydroid prop set persist.waydroid.width "800"
        ;;
esac
