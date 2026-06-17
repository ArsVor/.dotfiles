#!/bin/zsh

ATTACH=false
[[ "$1" == "--attach" ]] && ATTACH=true

SESSION="$2"

if tmux has-session -t "$SESSION" 2>/dev/null; then
	if [ -z $TMUX ]; then
		tmux -2 attach -t $SESSION:1
	else
		tmux switch-client -t $SESSION:1
	fi
	exit
fi


WD="$3"

tmux new-session -d -s $SESSION -c $WD
tmux split-window -h -t $SESSION:1.1 -c $WD
tmux new-window -c $WD -n shell -t $SESSION

if [[ -f ./manage.py ]]; then
    tmux split-window -v -t $SESSION:2.1 -c $WD
    tmux send-keys -t $SESSION:2.2 "uv run manage.py shell" C-m
fi

tmux resize-pane -Z -t $SESSION:1.1
tmux resize-pane -Z -t $SESSION:2.1

if $ATTACH; then
	if [ -z $TMUX ]; then
		tmux -2 attach -t $SESSION:1
	else
		tmux switch-client -t $SESSION:1
	fi
fi
