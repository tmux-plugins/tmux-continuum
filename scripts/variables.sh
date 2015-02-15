SUPPORTED_VERSION="1.9"

# these tmux options contain paths to tmux resurrect save and restore scripts
resurrect_save_path_option="@resurrect-save-script-path"
resurrect_restore_path_option="@resurrect-restore-script-path"

auto_save_interval_default="15"
auto_save_interval_option="@resurrect-auto-save-interval"

# time when the tmux environment was last saved (unix timestamp)
last_auto_save_option="@resurrect-auto-save-last-timestamp"

auto_restore_option="@resurrect-auto-restore"
auto_restore_default="off"

auto_restore_halt_file="${HOME}/tmux_no_auto_restore"
