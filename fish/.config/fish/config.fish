\oh-my-posh init fish --config $HOME/.poshthemes/ars.omp.json | source

set -g fish_greeting ""
set -gx EDITOR "/usr/local/bin/nvim"

set -gx CONFIG_SH_PATH "$HOME/.config/fish/config.fish"

set -gx PYENV_ROOT $HOME/.pyenv
set -gx PATH $PYENV_ROOT/bin $PATH

status --is-interactive; and . (pyenv init --path | psub)
status --is-interactive; and . (pyenv init - | psub)
status --is-interactive; and . (pyenv virtualenv-init - | psub)

if test -f $HOME/.config/fish_current_progect_env
    set -gx CURRENT_PROJECT $(cat $HOME/.config/fish_current_progect_env)
end

# fzf
set -x FZF_DEFAULT_COMMAND "fd --color=never --hidden --exclude .git --search-path /"
set -x FZF_DEFAULT_OPTS "--no-height --border"
set -x FZF_ALT_C_COMMAND "fd --type d . --color=never --hidden --exclude .git"
set -x FZF_ALT_C_OPTS "--preview 'tree --color=always {} | head -50'"

# Set up fzf key bindings
fzf --fish | source

# Custom fzf function
function fzf-file-widget-default
    set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set -x FZF_CTRL_T_OPTS ''
    fzf-file-widget
end

function fzf-file-widget-ctrl-f
    set -x FZF_CTRL_T_COMMAND "fd --type f --color=never --hidden --exclude .git --search-path ~/"
    set -x FZF_CTRL_T_OPTS "--reverse --preview 'bat --color=always --line-range :50 {}'"
    fzf-file-widget
end

function fzf-dir-widget
    set -x FZF_CTRL_T_COMMAND "fd --type d . --color=never --hidden --exclude .git --search-path ~/"
    set -x FZF_CTRL_T_OPTS "--reverse --preview 'tree --color=always {} | head -50'"
    fzf-file-widget
end

function fzf-ps-widget -d "List processes and return PID"
    # Зберігаємо вихідні параметри командного рядка
    set -l commandline (__fzf_parse_commandline)
    set -l prefix $commandline[3]

    # Налаштування висоти для FZF у tmux або стандартному терміналі
    test -n "$FZF_TMUX_HEIGHT"; or set FZF_TMUX_HEIGHT 40%

    # Генеруємо список процесів з ps aux із потрібними полями
    begin
        set -lx FZF_DEFAULT_OPTS "--reverse --header='USER       STATUS     COMMAND' --preview='ps o pid,priority,tty,pcpu,pmem,start_time,time {4}'"
        ps aux | awk '{printf "%-10s %-10s %-30s %s\n", $1, $8, $11, $2}' | fzf --with-nth=1,2,3 --query='' | while read -l line
            set -l pid (echo $line | awk '{print $NF}')
            if test -n "$pid"
                set -a result $pid
            end
        end
    end

    # Якщо нічого не вибрано, просто оновлюємо рядок
    if test -z "$result"
        commandline -f repaint
        return
    else
        # Видаляємо поточний введений текст і вставляємо PID у рядок
        commandline -t ""
    end

    # Вставляємо обраний PID
    for pid in $result
        commandline -it -- $prefix
        commandline -it -- $pid
        commandline -it -- ' '
    end
    commandline -f repaint
end

bind \ch fzf-ps-widget
bind \ct fzf-file-widget-default
bind \cf fzf-file-widget-ctrl-f
bind \cd fzf-dir-widget

if status is-interactive
    if not set -q FISH_CONFIG_SOURCED
        set -g FISH_CONFIG_SOURCED 1
        fastfetch
    end
end

if test -f ~/.config/alias.list
    source ~/.config/alias.list
end

# alias specific for fish

# venv
# alias vinit="python -m venv venv && pyenv deactivate && source ./venv/bin/activate.fish"
alias vrun="source ./venv/bin/activate.fish"
alias voff="deactivate"

function vinit
    python -m venv venv

    if not string match -q "system*" (pyenv version)
        pyenv deactivate
    end

    source ./venv/bin/activate.fish
end

function als
    set -l result (cat ~/.config/alias.list | rg '=' | sed 's/ /~~/' | sed 's/=/~~/' | sed 's/##/~~/' | awk -F ~~ '
               {printf "%-10s %-100s ~~%s\n", $2, $3, $4
                }' | fzf --reverse --no-multi --header="als         cmd" --preview="echo {} | awk -F \"~~\" '
                {print \$NF}' | fold -s -w 48" --preview-window=right:40%,wrap | awk '{print $1}')
        


    if test -z $result
        commandline -f repaint
        return
    else
        commandline -it -- $result
        commandline -it -- ' '
    end
    commandline -f repaint
end

bind \ea als

function ct
    date "+%H:%M:%S"
end

function myip
    echo (ifconfig | grep broadcast | awk '{print $2}')
end

function mdj
	mkdir -p $argv[1]
	cd $argv[1]
end

function bttr
    	echo $(cat /sys/class/power_supply/BAT0/capacity)% - $(cat /sys/class/power_supply/BAT0/status)
end

function mmry
	echo $(awk '/MemTotal/ {total=$2} /MemAvailable/ {available=$2} END {print int((total - available) / total * 100) "%"}' /proc/meminfo)
end

function swap
	echo $(awk '/SwapTotal/ {total=$2} /SwapFree/ {available=$2} END {print int((total - available) / total * 100) "%"}' /proc/meminfo)
end

function gco
    git checkout $(gl | fzf --reverse --height 50% | awk '{print $2}')
end

function pyrun 
    pyenv activate $(ls /home/ars/.pyenv/versions | rg py | awk '{print $1}' | fzf --cycle --height=25% --reverse)
end

function gsw
    git switch $(git branch | grep -v '^*' | fzf --reverse --height 50% | awk '{print $1}')
end

function gluch
    git lg $(git branch | grep -v '^*' | fzf --reverse --height 50% | awk '{print $1}')..HEAD
end

function glucb
    git lg $(git config --global init.defaultBranch)..$(git branch | sed 's/*/ /' |  grep -v $(git config --global init.defaultBranch) | fzf --reverse --height 50% | awk '{print $1}')
end

function glluch
    git log $(git branch | grep -v '^*' | fzf --reverse --height 50% | awk '{print $1}')..HEAD -p
end

function gllucb
    git log $(git config --global init.defaultBranch)..$(git branch | sed 's/*/ /' |  grep -v $(git config --global init.defaultBranch) | fzf --reverse --height 50% | awk '{print $1}') -p
end

function setcp
    set -l PROJECT $(pwd)
    # set -e CURRENT_PROJECT
    # set -e CURRENT_PROJECT
    # set -Ux CURRENT_PROJECT $PROJECT
    echo $PROJECT > $HOME/.config/fish_current_progect_env
    set -gx CURRENT_PROJECT $PROJECT
    echo "CURRENT_PROJECT встановлено на: $PROJECT"
end

function ..n
    set -l cmd ''
    set -l deep 1

    if test -n "$argv"
        set deep (math $argv[1])
    end

    while test $deep -gt 0 
       set cmd  $cmd'../'
       set deep (math $deep - 1)
    end

    cd $cmd
end
