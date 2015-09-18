#!/usr/bin/env bash

# for "true full screen" call the script with "fullscreen" as the first argument
TRUE_FULL_SCREEN="$1"
TMUX="$(which tmux)"

start_terminal_and_run_tmux() {
	x-terminal-emulator -e ./linux_shell_activator.sh $TMUX
}

resize_window_to_full_screen() {
	echo "Resize is up to terminal emulator being used." > /dev/null 2>&1
}

resize_to_true_full_screen() {
	echo "Resize is up to terminal emulator being used." > /dev/null 2>&1
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
