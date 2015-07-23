#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

auto_restore_enabled() {
	local auto_restore_value="$(get_tmux_option "$auto_restore_option" "$auto_restore_default")"
	[ "$auto_restore_value" == "on" ] && [ ! -f "$auto_restore_halt_file" ]
}

auto_kill_default_enabled() {
	local auto_kill_default_value="$(get_tmux_option "$auto_kill_default_option" "$auto_kill_default_default")"
	[ "$auto_kill_default_value" == "on" ]
}

fetch_and_run_tmux_resurrect_restore_script() {
	# give tmux some time to start and source all the plugins
	sleep 1
	local resurrect_restore_script_path="$(get_tmux_option "$resurrect_restore_path_option" "")"
	if [ -n "$resurrect_restore_script_path" ]; then
		"$resurrect_restore_script_path"
	fi
	if auto_kill_default_enabled; then
	  # Kill the default session created when tmux server starts
	  tmux kill-session -t 0
	fi
}

main() {
	# Advanced edge case handling: auto restore only if this is the only tmux
	# server. If another tmux server exists, it is assumed auto-restore is not wanted.
	if auto_restore_enabled && ! another_tmux_server_running_on_startup; then
		fetch_and_run_tmux_resurrect_restore_script
	fi
}
main
