#!/usr/bin/env bash

# for "true full screen" call the script with "fullscreen" as the first argument
TRUE_FULL_SCREEN="$1"

is_modern_iterm_version() {
osascript >/dev/null<<-EOF
on theSplit(theString, theDelimiter)
    set oldDelimiters to AppleScript's text item delimiters
    set AppleScript's text item delimiters to theDelimiter
    set theArray to every text item of theString
    set AppleScript's text item delimiters to oldDelimiters
    return theArray
end theSplit

on IsModernVersion(version)
	set myArray to my theSplit(version, ".")
	set major to item 1 of myArray
	set minor to item 2 of myArray
	set veryMinor to item 3 of myArray
	
	if major < 2 then
		return false
	end if
	if major > 2 then
		return true
	end if
	if minor < 9 then
		return false
	end if
	if minor > 9 then
		return true
	end if
	if veryMinor < 20140903 then
		return false
	end if
	return true
end IsModernVersion

tell application "iTerm"
  return my IsModernVersion(version)
end tell
EOF
}

start_iterm29_and_run_tmux() {
	osascript <<-EOF
    tell application "iTerm"
		#activate

		# open iterm window
		try
			set _session to current session of current window
		on error
            try
            -- if there is a profile named "tmux", then use it
              set _term to (create window with profile "tmux")
            on error
            -- otherwise just use default profile...
			  set _term to (create window with default profile)
            end try
			tell _term
			    launch session "Tmux"
				set _session to current session
			end tell
		end try

		# start tmux
		tell _session
			 write text "tmux_start"
		end tell
    end tell
	EOF
}

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

resize_iterm29_to_full_screen() {
osascript <<-EOF
tell application "iTerm"
  tell window 1
    set zoomed to true
  end tell
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

resize_iterm29_to_true_full_screen() {
	osascript <<-EOF
	tell application "iTerm"
		# wait for iTerm to start
		delay 1
		activate
		# short wait for iTerm to gain focus
		delay 0.1
		# Command + Enter for fullscreen
		tell application "System Events"
			key code 36 using {command down}
		end tell
	end tell
	EOF
}

main() {

    # iTerm2 scripting changes in version ~2.9
    # see https://iterm2.com/applescript.html
    if is_modern_iterm_version; then 
	  start_iterm29_and_run_tmux
	  if [ "$TRUE_FULL_SCREEN" == "fullscreen" ]; then
	  	  resize_iterm29_to_true_full_screen
	  else
	   	  resize_iterm29_to_full_screen
	  fi
    else
	  start_iterm_and_run_tmux
	  if [ "$TRUE_FULL_SCREEN" == "fullscreen" ]; then
	  	  resize_to_true_full_screen
	  else
	   	  resize_window_to_full_screen
	  fi
    fi
}
main
