#!/bin/zsh

SESSION="$1"
GIT_DIR=$(fd -H -d=2 "\\.git\$"  | sed -r 's/\/.git\///')
WD=$(pwd)
PD=$(dirname $WD)
# echo $GIT_DIR
# echo $WD
# echo $PD
# exit 0

if [[ -d $WD/venv ]]; then
	VENV="./venv"
elif [[ -d $WD/.venv ]]; then
	VENV="./.venv"
elif [[ -d $PD/venv ]]; then
	VENV="../venv"
elif [[ -d $PD/.venv ]]; then
	VENV="../.venv"
else
	VENV="nill"
fi

tmux new-session -d -s $SESSION 
tmux split-window -v -t $SESSION:1.1
if [[ $VENV != "nill" ]]; then
	tmux send-keys -t $SESSION:1.1 "source $VENV/bin/activate" C-m
	tmux send-keys -t $SESSION:1.1 "v" C-m
	tmux send-keys -t $SESSION:1.2 "source $VENV/bin/activate" C-m
fi
tmux resize-pane -Z -t $SESSION:1.1
tmux new-window -n zsh -t $SESSION
if [[ $GIT_DIR ]]; then
	tmux new-window -n Git -t $SESSION

	if [[ $GIT_DIR != ".git/" ]]; then
		tmux send-keys -t $SESSION:3.1 "cd $GIT_DIR" C-m
	fi

	tmux send-keys -t $SESSION:3.1 "lg" C-m
fi

if [[ $(echo $TMUX) ]]; then
	tmux switch-client -t $SESSION:1
else
	tmux -2 attach -t $SESSION:1
fi
