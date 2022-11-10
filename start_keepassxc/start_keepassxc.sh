#!/bin/env sh

# Scenario: Workaround allows YubiKey challenge-response for CLI unlock of
# KeepassXC file.

# Get .env relative to script
script_file=$( realpath "$0" )
script_dir=$( dirname "$script_file" )
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

echo $(ykchalresp -2 "$YKPASS") | \
	/usr/bin/keepassxc \
	--keyfile "$KEYFILE" \
	--pw-stdin \
	"$PASSFILE"
