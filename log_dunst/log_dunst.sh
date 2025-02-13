#!/usr/bin/env bash

# For use with `script` in `dunstrc`.

# Define the log file and its maximum size (in bytes)
LOG_DIR="${XDG_DATA_HOME}/dunst"
LOG_FILE="${LOG_DIR}/dunst.log"
MAX_SIZE=1048576 # 1 MB

# Define the number of old log files to keep
MAX_OLD_LOGS=5

# Create the log directory if it does not exist
if [ ! -d "$LOG_DIR" ]; then
    mkdir -p "$LOG_DIR" || {
        log_error "Failed to create directory $LOG_DIR"
        exit 1
    }
fi

# Function to rotate the log file
rotate_log() {
    if [ -f "$LOG_FILE" ]; then
        # Check if the log file exceeds the maximum size
        if [ "$(stat -c%s "$LOG_FILE")" -gt $MAX_SIZE ]; then
            # Rotate the log file
            for i in $(seq $MAX_OLD_LOGS -1 1); do
                if [ -f "${LOG_FILE}.${i}" ]; then
                    mv "${LOG_FILE}.${i}" "${LOG_FILE}.$((i + 1))"
                fi
            done
            mv "$LOG_FILE" "${LOG_FILE}.1"
        fi
    fi
}

# Rotate the log file if necessary
rotate_log

# Log the notification data
printf '%s\n' "$(date '+%Y-%m-%d %I:%M:%S%p'):$*" >>"$LOG_FILE"
