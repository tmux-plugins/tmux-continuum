#!/usr/bin/env bash

VERSION="$1"
UNSUPPORTED_MSG="$2"

# this is used to get "clean" integer version number. Examples:
# `tmux 1.9` => `19`
# `1.9a`     => `19`
get_digits_from_string() {
	local string="$1"
	local only_digits="$(echo "$string" | tr -dC '[:digit:]')"
	echo "$only_digits"
}

tmux_version_int() {
	local tmux_version_string=$(tmux -V)
	echo "$(get_digits_from_string "$tmux_version_string")"
}

exit_if_unsupported_version() {
	local current_version="$1"
	local supported_version="$2"
	if [ "$current_version" -lt "$supported_version" ]; then
		exit 1
	fi
}

main() {
	local supported_version_int="$(get_digits_from_string "$VERSION")"
	local current_version_int="$(tmux_version_int)"
	exit_if_unsupported_version "$current_version_int" "$supported_version_int"
}
main
