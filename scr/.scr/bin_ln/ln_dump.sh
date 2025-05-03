#!/bin/zsh

WD="${0:A:h}"
PREF="$HOME"

ls -la ~/.local/bin/ | grep ^l | sed "s|$PREF|~|g" | awk '{print $9, $11}' >$WD/bin_alias.list

echo "Saved symbolic links in format '<name> <path>'"
cat $WD/bin_alias.list
