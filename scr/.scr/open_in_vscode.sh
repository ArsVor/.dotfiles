#!/bin/bash

dir_count=0

args=$@

if (( ${#args[@]} > 0 )); then
	for arg in $args; do
		if [[  -d $arg ]]; then
			if (( $dir_count == 1 )); then
				echo "can't open more then 1 folder"
				exit 1
			else
				dir_count=1
			fi
		fi
	done
fi

flatpak run com.visualstudio.code $@
