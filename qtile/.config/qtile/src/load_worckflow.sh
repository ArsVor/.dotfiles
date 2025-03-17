#!/bin/zsh

xdotool set_desktop 0
/usr/bin/obsidian &
sleep 1.5

xdotool set_desktop 1
~/.scr/lounch_gpt.sh
/usr/bin/zen-browser &
sleep 1.5

xdotool set_desktop 2
/usr/bin/kitty &
