#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/../helpers.sh"
source "$CURRENT_DIR/../variables.sh"

template() {
	local tmux_start_script="$1"
	local content
	read -r -d '' content <<-EOF
	<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
	<plist version="1.0">
	<dict>
	    <key>Label</key>
	    <string>${osx_auto_start_file_name}</string>
	    <key>ProgramArguments</key>
	    <array>
	        <string>${tmux_start_script}</string>
	    </array>
	    <key>RunAtLoad</key>
	    <true/>
	</dict>
	</plist>
	EOF
	echo "$content"
}

get_iterm_or_teminal_option_value() {
	local options="$1"
	if [[ "$options" =~ "iterm" ]]; then
		echo "iterm"
	else
		# Terminal.app is the default console app
		echo "terminal"
	fi
}

get_fullscreen_option_value() {
	local options="$1"
	if [[ "$options" =~ "fullscreen" ]]; then
		# space prepended bc this will be a script argument
		echo " fullscreen"
	else
		echo ""
	fi
}

main() {
	local options="$(get_tmux_option "$auto_start_config_option" "$auto_start_config_default")"
	local iterm_or_terminal_value="$(get_iterm_or_teminal_option_value "$options")"
	local fullscreen_option_value="$(get_fullscreen_option_value "$options")"

	local launchd_plist_file_content="$(template "${CURRENT_DIR}/osx_${iterm_or_terminal_value}_start_tmux.sh${fullscreen_option_value}")"
	echo "$launchd_plist_file_content" > "$osx_auto_start_file_path"
}
main
