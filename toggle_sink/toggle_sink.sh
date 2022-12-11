#!/usr/bin/env bash

# Scenario: switch between 2 sinks.

# Set patterns for devices to be toggled. Have to match to second column
# in output of "pactl list short sinks".
# (Could also hardcode the full names, but this might be a little more robust)

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
: "$SINK1"
: "$SINK2"
: "$SINK1_STRING"
: "$SINK2_STRING"

# Discover which sink (output device) is active, and set up toggles
while read -r stream; do
  echo "$stream"
  if echo "$stream" | grep -q "RUNNING"; then
    currentSink=$(echo "$stream" | cut -f2)
  fi
  if echo "$stream" | grep -q "$SINK1"; then
    toggle1Sink=$(echo "$stream" | cut -f2)
  fi
  if echo "$stream" | grep -q "$SINK2"; then
    toggle2Sink=$(echo "$stream" | cut -f2)
  fi
done < <(pactl list short sinks)

# Set up where to switch to
if [ "$currentSink" = "$toggle1Sink" ]; then
  newSink=$toggle2Sink
  sink_string=$SINK2_STRING
else
  newSink=$toggle1Sink
  sink_string=$SINK1_STRING
fi

# Switch streams AND default sink
pactl list short sink-inputs | while read -r stream; do
  streamId=$(echo "$stream" | cut '-d ' -f1)
  # exclude echo cancellation module, but switch all other streams
  # You can, but don't have to remove if condition if no such module present
  if [ "$streamId" != "0" ]; then
    echo "moving stream $streamId"
    pactl move-sink-input "$streamId" "$newSink"
  fi
  # Also switch default sink, so media control keys work correctly
  pactl set-default-sink "$newSink"
done

dunstify -a "toggle_sink" -i media-playlist-shuffle "Audio Sink: $sink_string" -u low -r 991199
