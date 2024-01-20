#!/usr/bin/env bash

# for "true full screen" call the script with "fullscreen" as the first argument
TRUE_FULL_SCREEN="$1"

start_terminal_and_run_tmux() {
	osascript <<-EOF
	tell application "alacritty"
		activate
		delay 1
		tell application "System Events" to tell process "alacritty"
			set frontmost to true
			keystroke "tmux"
			key code 36
		end tell
	end tell
	EOF
}

resize_window_to_full_screen() {
	osascript <<-EOF
	tell application "alacritty"
		activate
		tell application "System Events"
			if (every window of process "alacritty") is {} then
				keystroke "n" using command down
			end if

			tell application "Finder"
				set desktopSize to bounds of window of desktop
			end tell

			set position of front window of process "alacritty" to {0, 0}
			set size of front window of process "alacritty" to {item 3 of desktopSize, item 4 of desktopSize}
		end tell
	end tell
	EOF
}

resize_to_true_full_screen() {
	osascript <<-EOF
	tell application "Alacritty"
		# wait for alacritty to start
		delay 1
		activate
		# short wait for alacritty to gain focus
		delay 0.1
		tell application "System Events" to tell process "Alacritty"
			if front window exists then
				tell front window
					if value of attribute "AXFullScreen" then
						set value of attribute "AXFullScreen" to false
					else
						set value of attribute "AXFullScreen" to true
					end if
				end tell
			end if	
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
