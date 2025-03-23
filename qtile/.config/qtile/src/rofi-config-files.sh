#!/bin/zsh

# Формуємо список
selected=$(rofi -dmenu -p "Choose .dotfile:" < <(
    fd -Htf --exclude=.git . ~/.dotfiles | sed -e "s|.*/\.dotfiles/||" | while read -r path; do
        file=${path:t}
        echo "$file - [$path]"
    done
))

# Витягуємо шлях
file_path=$(echo "$selected" | sed -E 's/.*\-\s\[(.*)\]/\1/')

# Перевіряємо, чи не пуста змінна, і відкриваємо файл
[ -n "$file_path" ] && xdg-open ~/.dotfiles/"$file_path"
