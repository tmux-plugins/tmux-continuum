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

current_tmux_server_pid() {
	echo "$TMUX" |
		cut -f2 -d","
}

current_tmux_socket_path() {
	echo "$TMUX" |
		cut -f1 -d","
}

# Counts other live tmux servers running for this user.
#
# A tmux server holds its socket FD with the socket's filesystem path
# in lsof's NAME column; a client only holds a peer-pointer connection
# (no path). Unique path-shaped NAMEs across `tmux` processes equal
# the set of servers. Each candidate is probed with `list-sessions` to
# exclude stale socket files from crashed servers.
#
# Falls back to scanning the current socket's directory if lsof is
# unavailable (covers default-dir cases, misses `-S /elsewhere/path`).
number_other_live_tmux_servers() {
	local current_socket socket_dir count sock candidates
	current_socket="$(current_tmux_socket_path)"
	count=0

	if command -v lsof >/dev/null 2>&1; then
		# Pull every absolute-path NAME column from `lsof -U` rows where
		# the command is `tmux` and the user is the current user. Dedupe.
		candidates="$(lsof -U -a -c tmux -u "$(id -u)" 2>/dev/null \
			| awk 'NR>1 && $NF ~ /^\// { print $NF }' \
			| sort -u)"
	elif [ -n "$current_socket" ]; then
		# Fallback: scan the current socket's directory only.
		socket_dir="$(dirname "$current_socket")"
		candidates="$(find "$socket_dir" -maxdepth 1 -type s 2>/dev/null)"
	else
		echo 0
		return
	fi

	for sock in $candidates; do
		[ "$sock" = "$current_socket" ] && continue
		if tmux -S "$sock" list-sessions >/dev/null 2>&1; then
			count=$((count + 1))
		fi
	done
	echo "$count"
}

another_tmux_server_running_on_startup() {
	[ "$(number_other_live_tmux_servers)" -gt 0 ]
}
