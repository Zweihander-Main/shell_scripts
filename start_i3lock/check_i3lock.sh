#!/usr/bin/env bash

# Scenario: Check i3lock is running, re-lock if not
# Useful for cron script if you want computer locked between a certain time

process_name="i3lock"

if ! pgrep -x "$process_name" >/dev/null; then
    loginctl lock-session
fi
