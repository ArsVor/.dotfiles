#!/bin/bash

MY_SHELL=$(echo $SHELL)

if [[ "$MY_SHELL" =~ "fish" ]]; then
	fish -c "source ~/.config/fish/config.fish"
elif [[ "$MY_SHELL" =~ "bash" ]]; then
	echo "bash"
	/bin/bash -c ". ~/.bashrc"
else
	echo "error: unknown shell - $MY_SHELL"
	exit 1
fi
