#!/usr/bin/env bash

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
	local display="$DISPLAY"

	read -r -d '' content <<-EOF
	[Unit]
	Description=tmux default session (detached)
	Documentation=man:tmux(1)
	After=graphical.target

	[Service]
	Type=forking
	Environment=DISPLAY=${display}
	ExecStart=${tmux_path} ${systemd_tmux_server_start_cmd}

	ExecStop=${resurrect_save_script_path}
	ExecStop=${tmux_path} kill-server
	KillMode=none

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
	mkdir -p "$(dirname ${systemd_unit_file_path})"
	echo "$systemd_unit_file"
}

write_unit_file() {
  systemd_unit_file > "${systemd_unit_file_path}"
}

write_unit_file_unless_exists() {
	if ! [ -e "${systemd_unit_file_path}" ]; then
    write_unit_file
	fi
}

main() {
  write_unit_file_unless_exists
	enable_tmux_unit_on_boot
}
main
