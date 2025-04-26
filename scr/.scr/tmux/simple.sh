#! /bin/zsh

ATTACH=false
[[ "$1" == "--attach" ]] && ATTACH=true

SESSION="$2"

tmux new-session -d -s $SESSION

if $ATTACH; then
	if [[ $(echo $TMUX) ]]; then
		tmux switch-client -t $SESSION:1
	else
		tmux -2 attach -t $SESSION:1
	fi
fi
