#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"
source "$CURRENT_DIR/shared.sh"

get_interval() {
	get_tmux_option "$auto_save_interval_option" "$auto_save_interval_default"
}

print_countdown() {
	local last_saved_timestamp="$(get_tmux_option "$last_auto_save_option" "0")"
	local interval_minutes="$(get_interval)"
	local interval_seconds="$((interval_minutes * 60))"
	local current_timestamp="$(current_timestamp)"
	local next_run="$((last_saved_timestamp + $interval_seconds))"
	echo $((($next_run - $current_timestamp) / 60))
}
print_countdown
