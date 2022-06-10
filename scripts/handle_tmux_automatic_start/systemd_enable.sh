#!/usr/bin/env bash

# Maintainer: Sven Vowe @nuclearglow
# Contact maintainer for any change to this file.

CURRENT_DIR="$( dirname ${BASH_SOURCE[0]} )"

source "$CURRENT_DIR/../helpers.sh"
source "$CURRENT_DIR/../variables.sh"

template() {
	local tmux_start_script="$1"
	shift
	local options="$@"
	local content=""
	local resurrect_save_script_path="$(get_tmux_option "$resurrect_save_path_option" "$(realpath ${CURRENT_DIR}/../../../tmux-resurrect/scripts/save.sh)")"
	local tmux_path="$(command -v tmux)"

	read -r -d '' content <<-EOF
	[Unit]
	Description=tmux default session (detached)
	Documentation=man:tmux(1)

	[Service]
	Type=forking
	Environment=DISPLAY=:0
	ExecStart=${tmux_path} ${systemd_tmux_server_start_cmd}

	ExecStop=${resurrect_save_script_path}
	ExecStop=${tmux_path} kill-server
	KillMode=control-group

	RestartSec=2

	[Install]
	WantedBy=default.target
	EOF

	echo "$content"
}

systemd_tmux_is_enabled() {
	systemctl --user is-enabled $(basename "${systemd_unit_file_path}") >/dev/null 2>&1
}

enable_tmux_unit_on_boot() {
	if ! systemd_tmux_is_enabled; then
		systemctl --user enable ${systemd_service_name}
	fi
}

systemd_unit_file() {
	local options="$(get_tmux_option "$auto_start_config_option" "${auto_start_config_default}")"
	local systemd_tmux_server_start_cmd="$(get_tmux_option "${systemd_tmux_server_start_cmd_option}" "${systemd_tmux_server_start_cmd_default}" )"
	local tmux_start_script_path="${CURRENT_DIR}/linux_start_tmux.sh"
	local systemd_unit_file=$(template "${tmux_start_script_path}" "${options}")
	echo "$systemd_unit_file"
}

write_unit_file() {
	systemd_unit_file > "${systemd_unit_file_path}"
}

write_unit_file_unless_exists() {
	local systemd_unit_file_dir=$(dirname ${systemd_unit_file_path})
	if ! [ -d $systemd_unit_file_dir ]; then
		mkdir -p $systemd_unit_file_dir
		write_unit_file
	elif ! [ -e "${systemd_unit_file_path}" ]; then
		write_unit_file
	fi
}

main() {
	write_unit_file_unless_exists
	enable_tmux_unit_on_boot
}
main
