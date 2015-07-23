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

auto_kill_default_option="@continuum-kill-default"
auto_kill_default_default="off"

auto_restore_halt_file="${HOME}/tmux_no_auto_restore"

# tmux auto start options
auto_start_option="@continuum-boot"
auto_start_default="off"

# comma separated list of additional options for tmux auto start
auto_start_config_option="@continuum-boot-options"
auto_start_config_default=""

osx_auto_start_file_name="Tmux.Start.plist"
osx_auto_start_file_path="${HOME}/Library/LaunchAgents/${osx_auto_start_file_name}"
