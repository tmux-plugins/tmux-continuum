#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

print_status() {
	local save_int="$(get_tmux_option "$auto_save_interval_option")"
	local status=""
	local style_wrap
	if [ $save_int -gt 0 ]; then
		style_wrap="$(get_tmux_option "$status_on_style_wrap_option" "")"
		status="$save_int"
	else
		style_wrap="$(get_tmux_option "$status_off_style_wrap_option" "")"
		status="off"
	fi

	if [ -n "$style_wrap" ]; then
		status="${style_wrap/$status_wrap_string/$status}"
	fi
	echo "$status"
}
print_status
