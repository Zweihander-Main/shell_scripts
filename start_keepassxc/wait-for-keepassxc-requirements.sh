#!/usr/bin/env bash

# Scenario: Workaround allows YubiKey challenge-response for CLI unlock of
# KeepassXC file.
# This script waits for the drives/yubikey to be ready. For use in ExecStartPre.

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
: "$YKPASS"
: "$KEYFILE"
: "$PASSFILE"
: "$MAX_SECONDS"
: "$YUBIKEY_PORT"

# Check key file exists and hopefully trigger automount in doing so
# Loop until it exists or maximum number of seconds is exceeded
start_time=$(date +%s)

until [[ -f "$KEYFILE" ]]; do
    current_time=$(date +%s)

    if [[ $((current_time - start_time)) -gt $MAX_SECONDS ]]; then
        echo "Key file can't be accessed"
        exit 1
    fi

    # Sleep for 1 second before checking again
    sleep 1
done

# Same for password file
until [[ -f "$PASSFILE" ]]; do
    current_time=$(date +%s)

    if [[ $((current_time - start_time)) -gt $MAX_SECONDS ]]; then
        echo "Password file can't be accessed"
        exit 1
    fi

    # Sleep for 1 second before checking again
    sleep 1
done

# Check yubikey is plugged in
# Loop until it is or max seconds is exceeded (counting from previous wait)
until ykinfo -"$YUBIKEY_PORT" >/dev/null 2>&1; do
    current_time=$(date +%s)

    if [[ $((current_time - start_time)) -gt $MAX_SECONDS ]]; then
        echo "Yubikey likely not plugged in."
        exit 1
    fi

    sleep 1
done

exit 0
