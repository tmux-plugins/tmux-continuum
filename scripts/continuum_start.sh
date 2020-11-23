#!/usr/bin/env bash

CURRENT_DIR="$( dirname "$0" )"

echo -e "\n$(date +%T) IN" >> /tmp/continuum

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

start_tmux() {
	local systemd_tmux_server_start_cmd="$(get_tmux_option "${systemd_tmux_server_start_cmd_option}" "${systemd_tmux_server_start_cmd_default}" )"
	/usr/bin/tmux ${systemd_tmux_server_start_cmd}
}

clean_session() {
	local sessions_count="$(tmux list-sessions 2>/dev/null | wc -l)"

	if /usr/bin/tmux has-session -t "${tmux_server_session_temporary}"; then
		# add a new session to preserve server daemon
		[ "${sessions_count}" = 1 ] && tmux new-session -d && \
			echo "$(date +%T) add session" >> /tmp/continuum

		# kill session
		echo "$(date +%T) kill session" >> /tmp/continuum
		/usr/bin/tmux kill-session -t "${tmux_server_session_temporary}"
	fi
}

main() {
	start_tmux

	# wait detached process of session restoration : start_auto_restore_in_background()
	# with a sleep 1 inside fetch_and_run_tmux_resurrect_restore_script()
	#sleep 1

	clean_session
}
main