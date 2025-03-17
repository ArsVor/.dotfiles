#!/bin/sh

source "$HOME/.config/xsecurelock/xsecurelockrc"
picom --config ~/.config/picom/picom.conf &
xdotool key Num_Lock &
~/.config/qtile/src/load_worckflow.sh

# auto screenlock
xset s 600 5
xset dpms 600 600 600
xss-lock -n /usr/lib/xsecurelock/dimmer -l -- xsecurelock &
