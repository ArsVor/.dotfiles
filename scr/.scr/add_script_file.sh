#!/bin/bash

#set -euxo pipefail

HELP="Usage: scr [OPTION] FILE_NAME
	
	Description:
	This script creates a new executable file with the specified shebang based on the provided FLAG, and then opens it in the default editor (set by $EDITOR, defaults to 'nano' if not set). If the file already exists, it prompts you to open it. The script also verifies if the target directory exists before file creation. If the target directory does not exists, it prompts you to create it (with parents directoryes if they does not exist).
	
	Options:
	  -b          Create a Bash script with the shebang '#!/bin/bash'.
	  -f          Create a Fish script with the shebang '#!/usr/bin/env fish'.
	  -p          Create a Python script with the shebang '#!/usr/bin/env python3'.
	  -pl		  Create a Python script with the shebang '#!./venv/bin/python'.
	  -z          Create a Zsh script with the shebang '#!/bin/zsh'.
	  --help      Display this help text and exit.
	
	Examples:
	  scr -b my_script.sh      Creates a Bash script named 'my_script.sh' in the current directory.
	  scr -p my_script.py      Creates a Python script named 'my_script.py' in the current directory.
	  scr my_script.sh         Creates a Bash script (default option) if no FLAG is specified.

	Notes:
	  - If FILE_NAME includes a path (e.g., 'dir/my_script.sh' ), that does not exist, the script will prompt you to create it.
	  - If the file already exists, the script will prompt you to open it without overwriting.
	  - The 'EDITOR' environment variable is used for opening the file; if it's not set, 'nano' will be used by default.
	"

empty_command () {
	echo -e "scr: no FILE_NAME\n\n(Type 'scr --help' for related documentation)\n"
	exit 1
}

if [[ $1 == "--help" ]]; then
	echo "$HELP"
	exit 0
fi

if ! [[ $1 ]]; then
	empty_command
fi

if [[ $1 =~ ^- ]]; then
	FLAG=$1
	if ! [[ $2 ]]; then
		empty_command
	else
		NAME=$2
	fi
else
	FLAG="-b"
	NAME=$1
fi

case $FLAG in
	-b)
		SHEBANG="#!/bin/bash"
		;;
	-f)
		SHEBANG="#!/usr/bin/env fish"
		;;
	-p)
		SHEBANG="#!/usr/bin/env python3"
		;;
	-pl)
		SHEBANG="#!./venv/bin/python"
		;;
	-z)
		SHEBANG="#!/bin/zsh"
		;;
	*)
		echo -e "scr: Unknown argument $FLAG\n\n(Type 'scr --help' for related documentation)\n"
		exit 1
		;;
esac	

if [[ $1 =~ ^\.\/ ]] || ! [[ $1 =~ / ]]; then
	FPATH=$(pwd)"/${NAME#./}"
else
	FPATH=$NAME
fi

# Перевірка наявності директорії
DIRNAME=$(dirname "$FPATH")
if ! [[ -d $DIRNAME ]]; then
    echo "Path: $DIRNAME does not exist."
    echo "Create path? [y/N]"
    	read -r CHOICE
    
    	if [[ $CHOICE =~ ^[yY]$ ]]; then
			mkdir -p $DIRNAME
    	else
    		exit 0
    	fi
fi

# Встановлення EDITOR за замовчуванням, якщо він не встановлений
: "${EDITOR:=nano}"

if ! [[ -f $FPATH ]]; then
	echo "$SHEBANG" > "$FPATH"
	chmod +x "$FPATH"
else
	echo "Script: $FPATH alredy exist."
	echo "Open it? [y/N]"
	read -r CHOICE

	if ! [[ $CHOICE =~ ^[yY]$ ]]; then
		exit 0
	fi
fi

"$EDITOR" "$FPATH"
