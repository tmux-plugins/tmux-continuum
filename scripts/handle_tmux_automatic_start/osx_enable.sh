#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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

main() {
	local launchd_plist_file_content="$(template "$CURRENT_DIR/osx_terminal_start_tmux.sh")"
	echo "$launchd_plist_file_content" > "$osx_auto_start_file_path"
}
main
