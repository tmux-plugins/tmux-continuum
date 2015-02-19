#!/usr/bin/env bash

# for "true full screen" call the script with "fullscreen" as the first argument
TRUE_FULL_SCREEN="$1"

start_iterm_and_run_tmux() {
	osascript <<-EOF
	tell application "iTerm"
		activate

		# open iterm window
		try
			set _session to current session of current terminal
		on error
			set _term to (make new terminal)
			tell _term
				launch session "Tmux"
				set _session to current session
			end tell
		end try

		# start tmux
		tell _session
			write text "tmux"
		end tell
	end tell
	EOF
}

resize_window_to_full_screen() {
	osascript <<-EOF
	tell application "iTerm"
		set winID to id of window 1
		tell i term application "Finder"
			set desktopSize to bounds of window of desktop
		end tell
		set bounds of window id winID to desktopSize
	end tell
	EOF
}

resize_to_true_full_screen() {
	osascript <<-EOF
	tell application "iTerm"
		# wait for iTerm to start
		delay 1
		activate
		# short wait for iTerm to gain focus
		delay 0.1
		# Command + Enter for fullscreen
		tell i term application "System Events"
			key code 36 using {command down}
		end tell
	end tell
	EOF
}

main() {
	start_iterm_and_run_tmux
	if [ "$TRUE_FULL_SCREEN" == "fullscreen" ]; then
		resize_to_true_full_screen
	else
		resize_window_to_full_screen
	fi
}
main
