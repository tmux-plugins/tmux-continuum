#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/../helpers.sh"
source "$CURRENT_DIR/../variables.sh"

template() {
	local tmux_start_script="$1"
	local is_fullscreen="$2"

	local fullscreen_tag=""
	if [ "$is_fullscreen" == "true" ]; then
		# newline and spacing so tag is aligned with other tags in template
		fullscreen_tag=$'\n        <string>fullscreen</string>'
	fi

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
	        <string>${tmux_start_script}</string>$fullscreen_tag
	    </array>
	    <key>RunAtLoad</key>
	    <true/>
	</dict>
	</plist>
	EOF
	echo "$content"
}

get_strategy() {
	local options="$1"
	if [[ "$options" =~ "iterm" ]]; then
		echo "iterm"
	elif [[ "$options" =~ "kitty" ]]; then
		echo "kitty"
	elif [[ "$options" =~ "alacritty" ]]; then
		echo "alacritty"
	else
		# Terminal.app is the default console app
		echo "terminal"
	fi
}

get_fullscreen_option_value() {
	local options="$1"
	if [[ "$options" =~ "fullscreen" ]]; then
		echo "true"
	else
		echo "false"
	fi
}

main() {
	local options="$(get_tmux_option "$auto_start_config_option" "$auto_start_config_default")"
	local strategy="$(get_strategy "$options")"
	local fullscreen_option_value="$(get_fullscreen_option_value "$options")"
	local tmux_start_script_path="${CURRENT_DIR}/osx_${strategy}_start_tmux.sh"

	local launchd_plist_file_content="$(template "$tmux_start_script_path" "$fullscreen_option_value")"
	echo "$launchd_plist_file_content" > "$osx_auto_start_file_path"
}
main
