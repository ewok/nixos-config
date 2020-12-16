#!/bin/env bash

if [ $1 -eq 1 ]; then
  setxkbmap -rules "evdev" -model "pc105" -layout "us,ru" -option "ctrl:swapcaps"
else
  setxkbmap -rules "evdev" -model "pc105" -layout "us,ru" -option
fi

pkill xcape
xcape
