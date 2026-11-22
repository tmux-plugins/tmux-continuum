get_tmux_option() {
	local option="$1"
	local default_value="$2"
	local option_value=$(tmux show-option -gqv "$option")
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

set_tmux_option() {
	local option="$1"
	local value="$2"
	tmux set-option -gq "$option" "$value"
}

# multiple tmux server detection helpers
#
# Another tmux server is detected by its socket, not by counting processes
# whose command starts with "tmux". Clients and short-lived helpers
# (`tmux show-option`, a status line script, a pane shell that has not exec'd
# yet) all look like that in `ps`, so a count of processes is wrong whenever
# any of them happens to be alive at that instant.

current_tmux_socket_path() {
	if [ -n "$TMUX" ]; then
		# $TMUX is "socket_path,server_pid,session_id"
		echo "${TMUX%,*,*}"
	else
		tmux display-message -p -F '#{socket_path}'
	fi
}

# Sockets that may belong to a tmux server of this user: everything in the
# default socket directory (default socket and `tmux -L name`), plus sockets
# given with `-S` on a tmux command line, which `ps` can still show.
# These are only candidates; each one is probed before it is counted.
candidate_tmux_sockets() {
	local socket_dir="${TMUX_TMPDIR:-/tmp}/tmux-$(id -u)"
	local socket
	for socket in "$socket_dir"/*; do
		echo "$socket"
	done
	ps -u "$(id -u)" -o command 2>/dev/null |
		sed -n 's/^tmux .*-S *\([^ ][^ ]*\).*/\1/p'
}

# Prints the number of live tmux servers of this user, other than the current one.
number_other_tmux_servers() {
	local current_socket="$(current_tmux_socket_path)"
	local counted=()
	local candidate
	local socket
	local seen
	while IFS= read -r candidate; do
		[ -S "$candidate" ] || continue
		[ "$candidate" -ef "$current_socket" ] && continue
		seen=""
		for socket in "${counted[@]}"; do
			[ "$candidate" -ef "$socket" ] && seen="yes" && break
		done
		[ -n "$seen" ] && continue
		# a leftover socket file of a dead server does not count
		if tmux -S "$candidate" list-sessions >/dev/null 2>&1; then
			counted+=("$candidate")
		fi
	done < <(candidate_tmux_sockets)
	echo "${#counted[@]}"
}

another_tmux_server_running() {
	[ "$(number_other_tmux_servers)" -gt 0 ]
}

another_tmux_server_running_on_startup() {
	another_tmux_server_running
}
