#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"
source "$CURRENT_DIR/shared.sh"

save_command_interpolation="#($CURRENT_DIR/scripts/resurrect_auto_save.sh)"

add_resurrect_save_interpolation() {
	local status_right_value="$(get_tmux_option "status-right" "")"
	local new_value="${save_command_interpolation}${status_right_value}"
	set_tmux_option "status-right" "$new_value"
}

main() {
	if supported_tmux_version_ok; then
		# Don't start saving right after tmux is started.
		# We wanna give user a chance to restore previous session.
		set_last_save_timestamp
		add_resurrect_save_interpolation
	fi
}
main