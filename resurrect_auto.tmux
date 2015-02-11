#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"

save_command_interpolation="#($CURRENT_DIR/scripts/resurrect_auto_save.sh)"

add_resurrect_save_interpolation() {
	local status_right_value="$(get_tmux_option "status-right" "")"
	local new_value="${save_command_interpolation}${status_right_value}"
	set_tmux_option "status-right" "$new_value"
}

main() {
	add_resurrect_save_interpolation
}
main
