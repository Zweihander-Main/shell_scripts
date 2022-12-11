#!/usr/bin/env bash

# Scenario: You have a folder full of videos and want to open the oldest one,
# moving it to a 'watched' folder in the process. This allows you to take any
# cognitive effort needed in terms of choosing a video out of the equation.

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
: "$DIR_FOR_VIDEOS"
: "$DIR_FOR_WATCHED_VIDEOS"
if [[ ! -d "$DIR_FOR_VIDEOS" ]]; then
    echo "Video directory doesn't exist"
    exit 1
fi
if [[ ! -d "$DIR_FOR_WATCHED_VIDEOS" ]]; then
    mkdir -p "$DIR_FOR_WATCHED_VIDEOS"
fi

# Initialize a variable to store the name of the oldest file
oldest_file=""
# Initialize a variable to store the time of the oldest file (in seconds since 1970)
oldest_time=9999999999

# Set IFS for whitespace in paths
IFS=$'\n'
for file in $(fd . "$DIR_FOR_VIDEOS" --maxdepth 1 --type f); do

    # Get the modification time of the current file
    mod_time=$(stat -c %Y "$file")

    # Get the mime-type of the current file
    mime_type=$(file --mime-type --no-pad "$file")
    is_video=$(echo "$mime_type" | grep --fixed-strings ': video/')

    # If the modification time of the current file is older than the
    # modification time of the oldest file, update the name and time of the
    # oldest file
    if [[ $mod_time -lt $oldest_time ]] && [[ "$is_video" ]]; then
        oldest_time=$mod_time
        oldest_file="$file"
    fi
done
unset IFS

# If we found an oldest file, open it using the "open" command
if [[ -n "$oldest_file" ]]; then
    file_basename=$(basename "$oldest_file")
    watched_location="$DIR_FOR_WATCHED_VIDEOS/$file_basename"
    mv "$oldest_file" "$watched_location"
    xdg-open "$watched_location"
fi
