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

while true; do
    if secret-tool lookup user "$SECRET_TOOL_USER"; then
        break
    fi
    sleep 5
done

exit 0
