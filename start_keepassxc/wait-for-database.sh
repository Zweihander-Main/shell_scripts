#!/usr/bin/env bash

# Scenario: Waits for secret-tool to be available which signifies that a
# database has been unlocked (assuming secret-service integration is enabled).

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
: "$SECRET_TOOL_USER"

function call_secret_tool() {
    secret-tool lookup user "$SECRET_TOOL_USER" &>/dev/null
    echo $? >"$1"
}

function check_secret_tool() {
    tmpfile=$(mktemp)
    call_secret_tool "$tmpfile" &
    timeout 1s xdotool search --sync --onlyvisible --name "KeepassXC -  Access Request" \
        windowfocus \
        keydown Enter \
        keyup --window 0 Enter
    wait
    output=$(cat "$tmpfile")
    rm "$tmpfile"
    if [ "$output" -eq 0 ]; then
        return 0
    fi
    return 1
}

while true; do
    if check_secret_tool; then
        break
    fi
    sleep 5
done

exit 0
