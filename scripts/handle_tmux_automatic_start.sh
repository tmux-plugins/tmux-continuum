#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

is_tmux_automatic_start_enabled() {
	local auto_start_value="$(get_tmux_option "$auto_start_option" "$auto_start_default")"
	[ "$auto_start_value" == "on" ]
}

is_osx() {
	[ $(uname) == "Darwin" ]
}

is_systemd() {
	[ $(ps -o comm= -p1) == 'systemd' ]
}

# Only manage the systemd unit either if it is not already installed, or if it
# was installed by us (as signified by the magic comment)
should_manage_systemd_unit() {
	[ ! -f ${systemd_unit_file_path} ] \
		&& \
	systemctl cat --user ${systemd_service_name} | grep -q 'managed-by:tmux-continuum'
}

main() {
	if is_tmux_automatic_start_enabled; then
		if is_osx; then
			"$CURRENT_DIR/handle_tmux_automatic_start/osx_enable.sh"
		elif is_systemd && should_manage_systemd_unit; then
			"$CURRENT_DIR/handle_tmux_automatic_start/systemd_enable.sh"
		fi
	else
		if is_osx; then
			"$CURRENT_DIR/handle_tmux_automatic_start/osx_disable.sh"
		elif is_systemd && should_manage_systemd_unit; then
			"$CURRENT_DIR/handle_tmux_automatic_start/systemd_disable.sh"
		fi
	fi
}
main
