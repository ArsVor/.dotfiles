#!/bin/sh

#source "$HOME/.config/xsecurelock/xsecurelockrc"
picom --config ~/.config/picom/picom.conf &
xdotool key Num_Lock &
xset s 0 0
xset dpms 0 0 0
dunst &
locker &
~/.config/qtile/src/load_worckflow.sh
systemctl --user restart libinput-gestures.service
