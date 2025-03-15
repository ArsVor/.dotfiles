#!/bin/zsh

xdotool set_desktop 0
/usr/bin/obsidian &
sleep 1.5

xdotool set_desktop 1
~/.scr/lounch_gpt.sh
sleep 1.5

xdotool set_desktop 3
/usr/bin/microsoft-edge-stable &
sleep 1.5

xdotool set_desktop 2
/usr/bin/kitty &
