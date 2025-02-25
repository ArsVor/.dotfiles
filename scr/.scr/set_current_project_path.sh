#!/bin/bash

PROJECT=$(pwd)

# Оновлення файлу зі змінною для Bash
echo "export CURRENT_PROJECT=$PROJECT" > ~/.config/bash_current_progect_env

# Оновлення Fish, якщо встановлений
if which fish >/dev/null 2>&1; then
    fish -c "set -e CURRENT_PROJECT; set -Ux CURRENT_PROJECT '$PROJECT'"

	# # Оновлення змінної в поточній Bash-сесії
	if [[ $(basename "$SHELL") == "bash" ]]; then
		# # echo "CURRENT_PROJECT встановлено на: $PROJECT"
		export CURRENT_PROJECT="$PROJECT"
		source $(echo $CONFIG_SH_PATH)
		source ~/.config/alias.list
	# elif [[ $(basename "$SHELL") == "fish" ]]; then
		# fish -c "source '$CONFIG_SH_PATH'"
		# # # # source ~/.config/alias.list
	fi
else
	export CURRENT_PROJECT="$PROJECT"
fi

echo "CURRENT_PROJECT встановлено на: $PROJECT"
printenv | rg 'CURRENT_PROJECT'
echo $CURRENT_PROJECT
