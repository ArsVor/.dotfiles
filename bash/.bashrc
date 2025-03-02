# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

bind '"\C-e": "\C-d"'
bind -x '"\C-d": "echo Disabled Ctrl+D\n"'

export CONFIG_SH_PATH="$HOME/.bashrc"

#export PATH="$HOME/.pyenv/bin:$PATH"
#eval "$(pyenv init --path)"
#eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"

# fzf configuration
export FZF_DEFAULT_COMMAND="fd --color=never --hidden --exclude .git --search-path /"
export FZF_DEFAULT_OPTS="--no-height --border"
export FZF_ALT_C_COMMAND="fd --type d . --color=never --hidden --exclude .git"
export FZF_ALT_C_OPTS="--preview 'tree --color=always {} | head -50'"


# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"
# source ~/.fzf-key-bindings.bash

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

if [ -f ~/.config/alias.list ]; then
    . ~/.config/alias.list
fi

if [ -f ~/.config/bash_current_progect_env ]; then
    . ~/.config/bash_current_progect_env
fi


# Перевірка на інтерактивний сеанс та чи викликано fastfetch раніше
if [[ $- == *i* ]] && [[ -z $FASTFETCH_RUN ]]; then
    export FASTFETCH_RUN=1
    fastfetch
fi

# alias specific for bash
alias myip="echo $(ifconfig | grep broadcast | awk '{print $2}')"
#alias ct='date "+%H:%M:%S"'
alias ct='echo $(date | awk "{print \$4}")'
alias gco='git checkout $(git lg | fzf --reverse --height 50%  | awk "{print \$2}")'
alias gsw='git switch $(git branch | grep -v "^*" | fzf --reverse --height 50% | awk "{print \$1}")'
alias gluch='git lg $(git branch | grep -v "^*" | fzf --reverse --height 50% | awk "{print \$1}")..HEAD'
alias glucb='gl $(git config --global init.defaultBranch)..$(git branch | sed "s/*/ /" |  grep -v $(git config --global init.defaultBranch) | fzf --reverse --height 50% | awk "{print $1}")'
alias glluch='git log $(git branch | grep -v "^*" | fzf --reverse --height 50% | awk "{print \$1}")..HEAD -p'
alias gllucb='gll $(git config --global init.defaultBranch)..$(git branch | sed "s/*/ /" |  grep -v $(git config --global init.defaultBranch) | fzf --reverse --height 50% | awk "{print $1}") -p'

# venv
alias venvinit="python -m venv venv && source ./venv/bin/activate"
alias venvrun="source ./venv/bin/activate"
alias venvoff="deactivate"

mdj() {
    mkdir -p "$1" && cd "$1"
}

mmry() {
	echo $(awk '/MemTotal/ {total=$2} /MemAvailable/ {available=$2} END {print int((total - available) / total * 100) "%"}' /proc/meminfo)
	
}

swap() {
	echo $(awk '/SwapTotal/ {total=$2} /SwapFree/ {available=$2} END {print int((total - available) / total * 100) "%"}' /proc/meminfo)	
}

bttr() {
	echo $(cat /sys/class/power_supply/BAT0/capacity)% - $(cat /sys/class/power_supply/BAT0/status)
}

pyrun() {
    pyenv activate $(ls /home/ars/.pyenv/versions | rg py | awk '{print $1}' | fzf --cycle --height=25% --reverse)
}

als() {
    # Зчитуємо alias.list, обробляємо його та отримуємо результат через fzf
    local result
    result=$(cat ~/.config/alias.list | rg '=' | sed 's/ /~~/' | sed 's/=/~~/' | sed 's/##/~~/' | awk -F '~~' '
        {printf "%-10s %-100s ~~%s\n", $2, $3, $4
        }' | fzf --reverse --no-multi --header="als         cmd" --preview="echo {} | awk -F \"~~\" '
        {print \$NF}' | fold -s -w 48" --preview-window=right:40%,wrap | awk '{print $1}')

    # Якщо результат порожній, просто оновлюємо термінал
    if [[ -z "$result" ]]; then
		echo "NO"
        tput sgr0 # Скидання кольорів (аналог repaint)
        return
    fi
	echo "OK"
    # Вставляємо команду в термінал
    READLINE_LINE="${READLINE_LINE:+$READLINE_LINE }$result"
    # READLINE_LINE="$result"
    READLINE_POINT=${#READLINE_LINE} # Переміщуємо курсор в кінець
}
bind -x '"\ea": als'

# # Custom fzf functions
# fzf-file-widget-default() {
    # export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    # export FZF_CTRL_T_OPTS=""
    # fzf-file-widget
# }
# 
# fzf-file-widget-ctrl-f() {
    # export FZF_CTRL_T_COMMAND="fd --type f --color=never --hidden --exclude .git --search-path ~/ "
    # export FZF_CTRL_T_OPTS="--reverse --preview 'bat --color=always --line-range :50 {}'"
    # fzf-file-widget
# }
# 
# fzf-dir-widget() {
    # export FZF_CTRL_T_COMMAND="fd --type d . --color=never --hidden --exclude .git --search-path ~/ "
    # export FZF_CTRL_T_OPTS="--reverse --preview 'tree --color=always {} | head -50'"
    # fzf-file-widget
# }
# 
# fzf-ps-widget() {
    # local result
    # local commandline=$(history | tail -n1)  # Аналог команди __fzf_parse_commandline
    # local prefix="${commandline:0:2}"       # Імітація парсингу введеного тексту
# 
    # export FZF_DEFAULT_OPTS="--reverse --header='USER       STATUS     COMMAND' --preview='ps o pid,priority,tty,pcpu,pmem,start_time,time {4}'"
    # result=$(ps aux | awk '{printf "%-10s %-10s %-30s %s\n", $1, $8, $11, $2}' | fzf --with-nth=1,2,3 --query='' | awk '{print $NF}')
    # 
    # if [ -n "$result" ]; then
        # READLINE_LINE="${READLINE_LINE}${prefix}${result} "
    # fi
# }
# 
# 
# bind '"\C-h":"fzf-ps-widget\n"'
# bind '"\C-t":"fzf-file-widget-default\n"'
# bind '"\C-f":"fzf-file-widget-ctrl-f\n"'
# bind '"\C-d":"fzf-dir-widget\n"'
