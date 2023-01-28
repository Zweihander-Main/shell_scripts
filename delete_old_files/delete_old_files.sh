#!/usr/bin/env bash

# Scenario: Delete files older than a preset number of days in a given folder.

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
: "$DIR_TO_DELETE_FROM"
: "$MAX_FILE_AGE_IN_DAYS"

if [[ ! -d "$DIR_TO_DELETE_FROM" ]]; then
    echo "Output directory doesn't exist"
    exit 1
fi

# Find all files in the directory that are older than given max age
files_to_delete=$(find $DIR_TO_DELETE_FROM -type f -mtime +$MAX_FILE_AGE_IN_DAYS)

# Loop through the files and delete them
for file in $files_to_delete; do
    echo "Deleting $file"
    rm -f $file
done
