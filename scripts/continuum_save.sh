#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"
source "$CURRENT_DIR/shared.sh"

supported_tmux_version_ok() {
	"$CURRENT_DIR/check_tmux_version.sh" "$SUPPORTED_VERSION"
}

get_interval() {
	get_tmux_option "$auto_save_interval_option" "$auto_save_interval_default"
}

auto_save_not_disabled() {
	[ "$(get_interval)" -gt 0 ]
}

enough_time_since_last_run_passed() {
	local last_saved_timestamp="$(get_tmux_option "$last_auto_save_option" "0")"
	local interval_minutes="$(get_interval)"
	local interval_seconds="$((interval_minutes * 60))"
	local next_run="$((last_saved_timestamp + $interval_seconds))"
	[ "$(current_timestamp)" -ge "$next_run" ]
}

fetch_and_run_tmux_resurrect_save_script() {
	local resurrect_save_script_path="$(get_tmux_option "$resurrect_save_path_option" "")"
	if [ -n "$resurrect_save_script_path" ]; then
		"$resurrect_save_script_path" "quiet" >/dev/null 2>&1 &
		set_last_save_timestamp
	fi
}

resurrect_dir() {
	local path="$(get_tmux_option "$resurrect_dir_option" "$default_resurrect_dir")"
	echo "${path/#\~/$HOME}" # expands tilde if used with @resurrect-dir
}

delete_old_saves() {
	# check if @resurrect-dir was set - if so use it
	local resurrect_save_dir=$(resurrect_dir)
	find $resurrect_save_dir -type f -mtime +7 -name "tmux_resurrect_*.txt" -exec rm -f {} +
}

main() {
	if supported_tmux_version_ok && auto_save_not_disabled && enough_time_since_last_run_passed; then
		fetch_and_run_tmux_resurrect_save_script
		
		local keeping_old_saves=$(get_tmux_option "$keep_old_saves_option" "")
		if [ -z "$keeping_old_saves" ]
		then
			delete_old_saves
		fi
	fi
}
main
