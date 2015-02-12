current_timestamp() {
	echo "$(date +%s)"
}

set_last_save_timestamp() {
	set_tmux_option "$last_auto_save_option" "$(current_timestamp)"
}

supported_tmux_version_ok() {
	$CURRENT_DIR/check_tmux_version.sh "$SUPPORTED_VERSION"
}
