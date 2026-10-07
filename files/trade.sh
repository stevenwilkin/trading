#!/bin/bash
#
# Start a tmux session with the trading dashboard layout:
#
#   +------+----------------------------+---------+
#   |      |                            | right 1 |
#   |      |                            +---------+
#   |      |                            |         |
#   | left |           shell            | right 2 |
#   |      |                            |         |
#   |      |                            +---------+
#   |      |                            | right 3 |
#   |      |                            +---------+
#   |      |                            | right 4 |
#   +------+----------------------------+---------+

SESSION=trade

LEFT_CMD="./levels"
RIGHT1_CMD="./positions"
RIGHT2_CMD="./metrics"
RIGHT3_CMD="./swaps"
RIGHT4_CMD="./treasury-cli"

attach() {
	if [ -n "$TMUX" ]; then
		tmux switch-client -t "$SESSION"
	else
		tmux attach-session -t "$SESSION"
	fi
}

if tmux has-session -t "$SESSION" 2>/dev/null; then
	attach
	exit
fi

# size the detached session to the current terminal so percentages are accurate
main=$(tmux new-session -d -s "$SESSION" -x "$(tput cols)" -y "$(tput lines)" -P -F '#{pane_id}')

# right column: 24% of the width
right1=$(tmux split-window -h -t "$main" -l 24% -P -F '#{pane_id}')

# left column: ~10% of the width (14% of the remaining 76%)
left=$(tmux split-window -h -b -t "$main" -l 14% -P -F '#{pane_id}')

# right column rows, top to bottom: ~22%, ~54%, ~13%, ~11%
right2=$(tmux split-window -v -t "$right1" -l 78% -P -F '#{pane_id}')
right3=$(tmux split-window -v -t "$right2" -l 31% -P -F '#{pane_id}')
right4=$(tmux split-window -v -t "$right3" -l 46% -P -F '#{pane_id}')

# send-keys rather than passing the command to split-window so each pane drops
# back to a shell if its command exits
tmux send-keys -t "$left" "$LEFT_CMD" C-m
tmux send-keys -t "$right1" "$RIGHT1_CMD" C-m
tmux send-keys -t "$right2" "$RIGHT2_CMD" C-m
tmux send-keys -t "$right3" "$RIGHT3_CMD" C-m
tmux send-keys -t "$right4" "$RIGHT4_CMD" C-m

tmux select-pane -t "$main"
attach
