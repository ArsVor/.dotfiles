#! /bin/zsh

SESSION="$1"

tmux new-session -d -s $SESSION

if [[ $(echo $TMUX) ]]; then
    tmux switch-client -t $SESSION:1
else
    tmux -2 attach -t $SESSION:1
fi
