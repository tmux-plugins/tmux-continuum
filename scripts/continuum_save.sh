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

output_current_continuum_status() {
	save_int=$(get_tmux_option "$auto_save_interval_option" | sed  "s/[^0-9]*\([0-9]\+\).*/\1/")
	status=""
	if [ $save_int -eq 0 ]
	then
		status="#[fg=yellow]off#[fg=white]"
	elif [ $save_int -gt 0 ]
	then
		status="#[fg=green,bold]"${save_int}"#[fg=white,nobold]"
	else
		status="#[fg=red]error#[fg=white]"
	fi
	local temp="#[fg=green,bold]"${save_int}"#[fg=white,nobold]"
	echo " "${status}" "
}

main() {
	if supported_tmux_version_ok && auto_save_not_disabled && enough_time_since_last_run_passed; then
		fetch_and_run_tmux_resurrect_save_script
	fi
	
	# if user has enabled show status option then insert into statusline
	if [ -n $(get_tmux_option "$show_continuum_status_option" "") ]
	then
		output_current_continuum_status
	fi
}
main
