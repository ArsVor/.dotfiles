#!/bin/zsh

WD="${0:A:h}"
PREF="$HOME"

if ! [[ -f "$WD/bin_alias.list" ]]; then
    echo "[ERROR] '$WD/bin_alias.list' file does not exist."
    return 1
fi

[[ ! -d $PREF/.local/bin ]] && mkdir -p $PREF/.local/bin

set_ln() {
    local als=$1

    if [[ $2 =~ ^\~ ]]; then
        local target=$PREF${2#\~}
    else
        local target=$2
    fi

    if [[ -f "$target" ]]; then
        if [[ -f $PREF/.local/bin/$als ]]; then
            echo "[WARNING] Alias '$als' is already exist."
            echo "Choose action: [S]kip, [o]verwrite, [r]ename"
            read -r choice </dev/tty

            if [[ "$choice" =~ ^[Oo]$ ]]; then
                rm $PREF/.local/bin/$als
                # echo "$PREF/.local/bin/$als is delited (NOT)" # test info
            elif [[ "$choice" =~ ^[Rr]$ ]]; then
                echo "Enter new name for alias:"
                read -r als </dev/tty

                while [[ -f $PREF/.local/bin/$als ]]; do
                    echo "Alias '$als' is already exist. Enter new name:"
                    read -r als </dev/tty
                done
            else
                echo "[INFO] Skipping alias creation for '$als'.\n"
                return
            fi
        fi
        ln -s $target $PREF/.local/bin/$als
        echo "[INFO] Make alias '$als' for '$target'\n"
    else
        echo "[WARNING] '$target' file for alias '$als' does not exist. Skipping."
    fi
}

while IFS=' ' read -r als target; do            # Читаємо порядково та розділяємо рядок на два аргументи
    [[ -z "$als" || -z "$target" ]] && continue # Пропускаємо пусті рядки
    set_ln "$als" "$target"
done <"$WD/bin_alias.list"
