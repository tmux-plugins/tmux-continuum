#!/usr/bin/env bash

CURRENT_DIR="$( dirname ${BASH_SOURCE[0]} )"
PARENT_DIR="${CURRENT_DIR%/*}"

source "${PARENT_DIR}/helpers.sh"
source "${PARENT_DIR}/variables.sh"

template() {
	local tmux_start_script="$1"
	shift
	local options="$@"
	local content=""

	read -r -d '' content <<-EOF
	[Unit]
	Description=tmux default session (detached)
	Documentation=man:tmux(1)

	[Service]
	Type=forking
	Environment=DISPLAY=:0
	ExecStart=${PARENT_DIR}/continuum_start.sh

	ExecStop=${HOME}/.tmux/plugins/tmux-resurrect/scripts/save.sh
	ExecStop=/usr/bin/tmux kill-server
	KillMode=none

	RestartSec=2

	[Install]
	WantedBy=default.target
	EOF

	echo "$content"
}

systemd_tmux_is_enabled() {
	systemctl --user is_enabled $(basename "${systemd_unit_file_path}") >/dev/null 2>&1
}

enable_tmux_unit_on_boot() {
	if ! systemd_tmux_is_enabled; then
		systemctl --user enable ${systemd_service_name}
	fi
}

main() {
	local options="$(get_tmux_option "$auto_start_config_option" "${auto_start_config_default}")"
	local tmux_start_script_path="${CURRENT_DIR}/linux_start_tmux.sh"
	local systemd_unit_file=$(template "${tmux_start_script_path}" "${options}")
	[ ! -d "$(dirname ${systemd_unit_file_path})" ] && mkdir -p "$(dirname ${systemd_unit_file_path})"
	echo "$systemd_unit_file" > "${systemd_unit_file_path}"
	enable_tmux_unit_on_boot
}
main
