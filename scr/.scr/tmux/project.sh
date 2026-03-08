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
PD=$(dirname $WD)
# GIT_DIR=$(fd -H -d=2 "\\.git\$" $WD  | sed -r 's/\/.git\///')

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

tmux new-session -d -s $SESSION -c $WD
tmux split-window -h -t $SESSION:1.1
tmux new-window -c $WD -n shell -t $SESSION
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

# if [[ $GIT_DIR ]]; then
# 	tmux new-window -c $GIT_DIR -n Git -t $SESSION 'lazygit'
# 	# tmux set-option -t $SESSION:3.1 remain-on-exit on 
#
# 	tmux send-keys -t $SESSION:3.1 "lg" C-m
# fi

if $ATTACH; then
	if [ -z $TMUX ]; then
		tmux -2 attach -t $SESSION:1
	else
		tmux switch-client -t $SESSION:1
	fi
fi
