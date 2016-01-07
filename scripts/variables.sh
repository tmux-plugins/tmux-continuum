SUPPORTED_VERSION="1.9"

# these tmux options contain paths to tmux resurrect save and restore scripts
resurrect_save_path_option="@resurrect-save-script-path"
resurrect_restore_path_option="@resurrect-restore-script-path"

auto_save_interval_option="@continuum-save-interval"
auto_save_interval_default="15"

# time when the tmux environment was last saved (unix timestamp)
last_auto_save_option="@continuum-save-last-timestamp"

auto_restore_option="@continuum-restore"
auto_restore_default="off"

auto_restore_halt_file="${HOME}/tmux_no_auto_restore"

# tmux auto start options
auto_start_option="@continuum-boot"
auto_start_default="off"

# comma separated list of additional options for tmux auto start
auto_start_config_option="@continuum-boot-options"
auto_start_config_default=""

osx_auto_start_file_name="Tmux.Start.plist"
osx_auto_start_file_path="${HOME}/Library/LaunchAgents/${osx_auto_start_file_name}"

status_interpolation_string="\#{continuum_status}"
status_script="#($CURRENT_DIR/scripts/continuum_status.sh)"
# below options set style/color for #{continuum_status} interpolation
status_on_style_wrap_option="@continuum-status-on-wrap-style"   # example value: "#[fg=green]#{value}#[fg=white]"
status_off_style_wrap_option="@continuum-status-off-wrap-style" # example value: "#[fg=yellow,bold]#{value}#[fg=white,nobold]"
status_wrap_string="\#{value}"

systemd_service_name="tmux.service"
systemd_unit_file_path="$HOME/.config/systemd/user/${systemd_service_name}"

systemd_tmux_server_start_cmd_option="@continuum-systemd-start-cmd"
systemd_tmux_server_start_cmd_default="new-session -d"
