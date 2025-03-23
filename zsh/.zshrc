#!/bin/zsh


stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments
setopt ignore_eof # Do not exit then pressed ctrl+d 

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"


# User specific environment
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
export PATH

ZSHCONFDIR="$HOME/.config/zsh"

export CONFIG_SH_PATH="$HOME/.zshrc"
export EDITOR="/usr/bin/nvim"

#### fzf default exports ####
export FZF_DEFAULT_COMMAND="fd --color=never --hidden --exclude .git --search-path /"
export FZF_DEFAULT_OPTS="--no-height --border"
export FZF_ALT_C_COMMAND="fd --type d . --color=never --hidden --exclude .git"
export FZF_ALT_C_OPTS="--preview 'exa -Ta --color=always {} | head -50'"

# Перевірка на інтерактивний сеанс та чи викликано fastfetch раніше
if [[ $- == *i* ]] && [[ -z $FASTFETCH_RUN ]]; then
    export FASTFETCH_RUN=1
    fastfetch
fi

#### Source ####
source "$HOME/.config/alias.list"
source "$ZSHCONFDIR/zsh-functions"

zsh_add_source "zsh-aliases"

zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-history-substring-search"

# set truncated path for starship prompt
export TRUNCATED_PATH=$(trunc_path)
chpwd() {
    export TRUNCATED_PATH=$(trunc_path)
}

#### Basic auto/tab complete ####
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

#### History ####
HISTFILE=~/.cache/zsh/zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt HIST_IGNORE_SPACE  # Don't save when prefixed with space
setopt HIST_IGNORE_DUPS   # Don't save duplicate lines
setopt SHARE_HISTORY      # Share history between sessions

# zsh-history-substring-search configuration
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

#### Sesh keybind ####
zle     -N             sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions


#### vi mode ####
bindkey -v
export KEYTIMEOUT=1

bindkey -v '^?' backward-delete-char
if [[ -o menucomplete ]]; then 
  # Use vim keys in tab complete menu:
  bindkey -M menuselect 'h' vi-backward-char
  bindkey -M menuselect 'k' vi-up-line-or-history
  bindkey -M menuselect 'l' vi-forward-char
  bindkey -M menuselect 'j' vi-down-line-or-history
fi

zle -N trig_vi_escape
bindkey -M viins 'j' trig_vi_escape
zle -N zle-keymap-select
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

#### fzf keybind ####
zle -N fzf-ps-widget
zle -N fzf-file-widget-default
zle -N fzf-file-widget-ctrl-f
zle -N fzf-dir-widget
zle -N als

bindkey '^p' fzf-ps-widget
bindkey '^t' fzf-file-widget-default
bindkey '^f' fzf-file-widget-ctrl-f
bindkey '^d' fzf-dir-widget
bindkey '\ea' als

#### Tmux session auto start ####
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t default || tmux new-session -d -s default
fi


autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

