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

lock_dir() {
	echo "/tmp/tmux-continuum-$(current_tmux_server_pid)-lock"
}

fetch_and_run_tmux_resurrect_save_script() {
	local resurrect_save_script_path="$(get_tmux_option "$resurrect_save_path_option" "")"
	local lockdir="$(lock_dir)"
	if [ -n "$resurrect_save_script_path" ]; then
		# The save runs in the background so this script returns promptly. The
		# lock is released by the background subshell once the save finishes,
		# so it is held for the full duration of the save rather than a fixed
		# time window.
		(
			echo "$BASHPID" > "$lockdir/pid"
			trap 'rm -rf "$lockdir"' EXIT
			"$resurrect_save_script_path" "quiet"
		) >/dev/null 2>&1 &
		set_last_save_timestamp
	else
		rm -rf "$lockdir"
	fi
}

acquire_lock() {
	# Sometimes tmux starts multiple saves in parallel. We want only one
	# save to be running, otherwise we can get corrupted saved state.
	local lockdir="$(lock_dir)"
	if mkdir "$lockdir" 2>/dev/null; then
		return 0
	fi
	# Someone else has the lock. Is that save still running?
	local holder="$(cat "$lockdir/pid" 2>/dev/null)"
	if [ -n "$holder" ] && kill -0 "$holder" 2>/dev/null; then
		return 1
	fi
	# The holder has not written its pid yet, or it died without cleaning up
	# (killed mid-save, machine crashed). Only reclaim a lock that is old
	# enough to rule out the former.
	if [ -z "$(find "$lockdir" -maxdepth 0 -mmin +1 2>/dev/null)" ]; then
		return 1
	fi
	rm -rf "$lockdir" 2>/dev/null
	mkdir "$lockdir" 2>/dev/null
}

main() {
	if supported_tmux_version_ok && auto_save_not_disabled && enough_time_since_last_run_passed && acquire_lock; then
		fetch_and_run_tmux_resurrect_save_script
	fi
}
main
