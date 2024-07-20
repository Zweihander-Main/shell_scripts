#!/usr/bin/env bash

# Scenario: start DWM, allow for restarts, log errors to file

# Get .env relative to script
script_file=$(realpath "$0")
script_dir=$(dirname "$script_file")
env="${script_dir}/.env"

# Exit if no .env
# shellcheck source=.env
. "$env" || exit 1

# Source .env
set -o allexport
# shellcheck source=.env
source "$env"
set +o allexport

# Make sure all variables present and sane
set -o nounset
: "$LOG_LOC"

if [ ! -f "$LOG_LOC" ]; then
	mkdir -p "$(dirname "$LOG_LOC")"
	touch "$LOG_LOC"
fi

# Allow for MOD-C-S-Q to restart DWM
while true; do
	# Log stderror to a file
	dwm 2>"$LOG_LOC"

	# Kill stalonetray if running
	if pgrep stalonetray >/dev/null; then
		pkill stalonetray
	fi
done
