#!/bin/zsh


ATTACH=false
[[ "$1" == "--attach" ]] && ATTACH=true

SESSION="TASKS"

tmux new-session -d -s $SESSION -n tasksh
tmux new-window -n zsh -t $SESSION
tmux new-window -n request -t $SESSION
tmux send-keys -t $SESSION:1.1 "tasksh" C-m
tmux send-keys -t $SESSION:3.1 "cd ~/projects/requests" C-m
tmux send-keys -t $SESSION:1.1 "! clear" C-m
tmux send-keys -t $SESSION:1.1 "list" C-m
tmux send-keys -t $SESSION:3.1 "nvim" C-m
tmux select-window -t $SESSION:1
tmux select-pane -t $SESSION:1.1

if $ATTACH; then
	if [[ $(echo $TMUX) ]]; then
		tmux switch-client -t $SESSION:1
	else
		tmux -2 attach -t $SESSION:1
	fi
fi
