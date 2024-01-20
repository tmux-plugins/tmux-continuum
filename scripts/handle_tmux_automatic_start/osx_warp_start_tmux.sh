# Maintainer: Dimitar Nizamov @dimitur2204 
# Contact maintainer for any change to this file.
#!/usr/bin/env bash

# for "true full screen" call the script with "fullscreen" as the first argument
TRUE_FULL_SCREEN="$1"

start_terminal_and_run_tmux() {
	osascript <<-EOF
	tell application "Warp"
		activate
		delay 5
		tell application "System Events" to tell process "Warp"
			set frontmost to true
			keystroke "tmux"
			key code 36
		end tell
	end tell
	EOF
}

resize_window_to_full_screen() {
	osascript <<-EOF
	tell application "Warp"
		activate
		tell application "System Events"
			if (every window of process "Warp") is {} then
				keystroke "n" using command down
			end if

			tell application "Finder"
				set desktopSize to bounds of window of desktop
			end tell

			set position of front window of process "Warp" to {0, 0}
			set size of front window of process "Warp" to {item 3 of desktopSize, item 4 of desktopSize}
		end tell
	end tell
	EOF
}

resize_to_true_full_screen() {
	osascript <<-EOF
	tell application "Warp"
		activate
		delay 1
		tell application "System Events" to tell process "Warp"
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
