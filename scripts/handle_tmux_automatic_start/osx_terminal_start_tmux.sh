#!/usr/bin/env bash

# for "true full screen" call the script with "fullscreen" as the first argument
TRUE_FULL_SCREEN="$1"

start_terminal_and_run_tmux() {
	osascript <<-EOF
	tell application "Terminal"
		if not (exists window 1) then reopen
		activate
		set winID to id of window 1
		do script "tmux" in window id winID
	end tell
	EOF
}

resize_window_to_full_screen() {
	osascript <<-EOF
	tell application "Terminal"
		set winID to id of window 1
		tell application "Finder"
			set desktopSize to bounds of window of desktop
		end tell
		set bounds of window id winID to desktopSize
	end tell
	EOF
}

resize_to_true_full_screen() {
	osascript <<-EOF
	tell application "Terminal"
		# waiting for Terminal.app to start
		delay 1
		activate
		# short wait for Terminal to gain focus
		delay 0.1
		tell application "System Events"
			keystroke "f" using {control down, command down}
		end tell
	end tell
	EOF
}

main() {
	start_terminal_and_run_tmux
	if [ "$TRUE_FULL_SCREEN" == "fullscreen" ]; then
		resize_to_true_full_screen
	else
		resize_window_to_full_screen
	fi
}
main
