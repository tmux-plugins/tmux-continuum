#!/usr/bin/env bash

# Maintainer: Sven Vowe @nuclearglow
# Contact maintainer for any change to this file.

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/../variables.sh"

main() {
	systemctl --user disable ${systemd_service_name}
}
main
