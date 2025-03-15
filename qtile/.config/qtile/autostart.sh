#!/bin/sh

picom --config ~/.config/picom/picom.conf &
xdotool key Num_Lock &
libinput-gestures-setup star
~/.config/qtile/src/load_worckflow.sh
