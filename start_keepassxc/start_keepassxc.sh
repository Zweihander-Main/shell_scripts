#!/usr/bin/env bash

# Scenario: Workaround allows YubiKey challenge-response for CLI unlock of
# KeepassXC file.
# This file starts the program and expects wait-for-keepassxc-requirements.sh to
# have been run (likely in ExecStartPre).

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
: "$YUBIKEY_PORT"

# Open KeepassXC with Yubikey challenge
echo $(ykchalresp -"$YUBIKEY_PORT" "$YKPASS") |
    /usr/bin/keepassxc \
        --keyfile "$KEYFILE" \
        --pw-stdin \
        "$PASSFILE"
