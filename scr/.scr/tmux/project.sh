#!/bin/zsh

ATTACH=false
[[ "$1" == "--attach" ]] && ATTACH=true

SESSION="$2"
GIT_DIR=$(fd -H -d=2 "\\.git\$"  | sed -r 's/\/.git\///')
WD=$(pwd)
PD=$(dirname $WD)


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
tmux split-window -h -t $SESSION:1.1
tmux new-window -n shell -t $SESSION
if [[ $VENV != "nill" ]]; then
	# tmux send-keys -t $SESSION:1.1 "source $VENV/bin/activate" C-m
	tmux send-keys -t $SESSION:1.1 "v" C-m
	tmux send-keys -t $SESSION:1.1 ":PyLspActivateVenv .venv" C-m
	# tmux send-keys -t $SESSION:1.1 ":AutoSelectSystemVenv" C-m
	# tmux send-keys -t $SESSION:1.2 "source $VENV/bin/activate" C-m

	if [[ -f ./manage.py ]]; then
		tmux split-window -v -t $SESSION:2.1
		# tmux send-keys -t $SESSION:2.2 "source $VENV/bin/activate" C-m
		tmux send-keys -t $SESSION:2.2 "uv run manage.py shell" C-m
	fi
fi
tmux resize-pane -Z -t $SESSION:1.1
tmux resize-pane -Z -t $SESSION:2.1
if [[ $GIT_DIR ]]; then
	tmux new-window -n Git -t $SESSION

	if [[ $GIT_DIR != ".git/" ]]; then
		tmux send-keys -t $SESSION:3.1 "cd $GIT_DIR" C-m
	fi

	tmux send-keys -t $SESSION:3.1 "lg" C-m
fi

if $ATTACH; then
	if [[ $(echo $TMUX) ]]; then
		tmux switch-client -t $SESSION:1
	else
		tmux -2 attach -t $SESSION:1
	fi
fi
