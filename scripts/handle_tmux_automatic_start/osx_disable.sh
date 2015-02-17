#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/../variables.sh"

main() {
	rm "$osx_auto_start_file_path" > /dev/null 2>&1
}
main
