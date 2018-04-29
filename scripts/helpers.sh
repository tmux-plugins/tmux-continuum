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

all_tmux_processes() {
	# finds all tmux processes for the current user ignoring the following:
  # 1) `tmux source-file .tmux.conf` (used to reload tmux.conf)
  # 2) `tmux a` (which shows an additional process)

  ps -Ao "command pid uid" |\
    grep $UID |\
    grep -E '^tmux' |\
    grep -vE '^tmux\s+(a|source)'
}

number_tmux_processes_except_current_server() {
	all_tmux_processes |
		\grep -v " $(current_tmux_server_pid)$" |
		wc -l |
		sed "s/ //g"
}

number_current_server_client_processes() {
	tmux list-clients |
		wc -l |
		sed "s/ //g"
}

another_tmux_server_running_on_startup() {
	# there are 2 tmux processes (current tmux server + 1) on tmux startup
	[ "$(number_tmux_processes_except_current_server)" -gt 1 ]
}
