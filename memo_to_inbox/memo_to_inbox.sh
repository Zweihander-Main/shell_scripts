#!/usr/bin/env bash

# Scenario: You have a mail folder pulled in via isync in which you want to
# convert all the message bodies to org format and mark them read.

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
: "$NOTMUCH_SEARCH_STRING"
: "$MBSYNC_CONFIG"
: "$INBOX_FILE"
if [[ ! -f "$INBOX_FILE" ]]; then
    echo "Inbox file doesn't exist"
    exit 1
fi

set -o noclobber

# Save all open buffers in emacs (preventing conflicting disk overwrite)
killall -s SIGUSR1 emacs

# Sync and index email
mbsync -c "${MBSYNC_CONFIG}" --all
notmuch new

# Fetch notmuch data in json format and use jq to comb through
messages_count=$(notmuch count "${NOTMUCH_SEARCH_STRING}")
messages_json=$(notmuch show --format=json "${NOTMUCH_SEARCH_STRING}")
body_str=$(jq -r '[.[][][0].body[].content] | reverse | @sh' <(echo "${messages_json}"))

# Filter end newlines
body_str_cleaned=$(awk ' /^$/ { print; } /./ { printf("%s", $0); } ' <(echo "$body_str"))

# Create array, then use it to format org string
declare -a body_array="($body_str_cleaned)"
to_append=""
for i in "${body_array[@]}"; do
    to_append+="* TODO ${i}\n"
done

# Sanity check -- make sure notmuch data was parsed correctly
if [ "${#body_array[@]}" -ne "${messages_count}" ]; then
    echo "Error: bad json parsing."
    echo "New emails appending: ${#body_array[@]}"
    echo "Notmuch search count: ${messages_count}"
    exit 1
fi

if [ "${messages_count}" -eq 0 ]; then
    echo "No new messages to append."
    exit 0
fi

# Append to inbox and save
echo -e "${to_append}" >>"${INBOX_FILE}"
killall -s SIGUSR1 emacs

# Mark unread and sync changes
notmuch tag -unread "${NOTMUCH_SEARCH_STRING}"
sleep 1
mbsync -c "${MBSYNC_CONFIG}" --all
