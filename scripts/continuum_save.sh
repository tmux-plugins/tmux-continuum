#!/usr/bin/env bash
set +x
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"
source "$CURRENT_DIR/shared.sh"

DEBUG=$(get_tmux_option "$debug")

get_log_path() {
  get_tmux_option "$log_path" "$log_path_default"
}

log_message() {
  log_path=$(get_log_path)
  if [ "$DEBUG" == "1" ] && [ -n "$log_path" ]; then
    message="$@"
    echo "$message" >> $log_path
  fi
}

supported_tmux_version_ok() {
	"$CURRENT_DIR/check_tmux_version.sh" "$SUPPORTED_VERSION"
}

get_interval() {
	get_tmux_option "$auto_save_interval_option" "$auto_save_interval_default"
}

auto_save_not_disabled() {
	[ "$(get_interval)" -gt 0 ]
}

get_next_run() {
	local last_saved_timestamp="$(get_tmux_option "$last_auto_save_option" "0")"
	local interval_minutes="$(get_interval)"
	local interval_seconds="$((interval_minutes * 60))"
	local next_run="$((last_saved_timestamp + $interval_seconds))"
  echo $next_run
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
    if [ "$DEBUG" == "1" ]; then
      local log_path=$(get_log_path)
      log_message "Calling $resurrect_save_script_path"
		  "$resurrect_save_script_path" >> $log_path 2>&1 &
    else
		  "$resurrect_save_script_path" "quiet" >/dev/null 2>&1 &
    fi
		set_last_save_timestamp
	fi
}

main() {
  if [ -n "$DEBUG" ]; then
    TS_NEXT=$(get_next_run)
    TIME_NEXT=$(date -d \@"$TS_NEXT" +"%Y-%m-%d at %H:%M:%S")
    MSG="Next save on $TIME_NEXT"
    log_message "$(date +'%Y-%m-%d %H:%M:%S'): $MSG"
  fi
	if supported_tmux_version_ok && auto_save_not_disabled && enough_time_since_last_run_passed; then
    if [ -n "$DEBUG" ]; then
      log_message "Actual run on $(date)"
      echo "Saved on $(date +'%Y-%m-%d@%H:%M:%S')"
    fi
		fetch_and_run_tmux_resurrect_save_script
	fi
}
main
