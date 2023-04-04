#!/usr/bin/env bash

# Scenario: You have a Nextcloud news account for video RSS feeds. You want to
# download everything unread using youtube-dl.

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
: "$USERNAME"
: "$PASSWORD"
: "$BASE_URL"
: "$OUTPUT_DIR"
: "$FAILED_FILE"
if [[ ! -d "$OUTPUT_DIR" ]]; then
    echo "Output directory doesn't exist"
    exit 1
fi

# Help message
if [[ $1 == "-h" || $1 == "--help" ]]; then
    echo "Usage: download_nextcloud [count]"
    echo "Downloads [count] unread items from Nextcloud. If count is not specified, defaults to max unread."
    exit 0
fi

# -f for non-2xx/3xx codes as errors
# -sS for disabling progress meter
# -L follow redirects
# URL fetches unread articles from all feeds
return_data=$(curl \
    -f \
    -Ss \
    -L \
    -X GET \
    --user "$USERNAME:$PASSWORD" \
    -H "Accept: \"application/json\"" \
    "$BASE_URL/apps/news/api/v1-2/items?type=3&getRead=false&batchSize=-1")

# -r to remove quotes (raw-output)
urls_string=$(jq -r '.items[].url' <(echo "$return_data"))
ids_string=$(jq -r '.items[].id' <(echo "$return_data"))

while read -r line; do urls+=("$line"); done <<<"$urls_string"
while read -r line; do ids+=("$line"); done <<<"$ids_string"

if [ ! "${urls[0]}" ]; then
    echo "No items found"
    exit 0
fi

pushd "$OUTPUT_DIR" || exit 1

if [[ $# -eq 1 && $1 =~ ^[0-9]+$ ]]; then
    count=$1
else
    count=${#urls[@]}
fi

for ((i = 0; i < ${count}; ++i)); do
    url="${urls[$i]}"
    id="${ids[$i]}"
    if ! youtube-dl -q "$url"; then
        echo "$url" >>"$FAILED_FILE"
    fi
    # URL marks item read
    curl \
        -f \
        -Ss \
        -L \
        -X PUT \
        --user "$USERNAME:$PASSWORD" \
        -H "Accept: \"application/json\"" \
        "$BASE_URL/apps/news/api/v1-2/items/$id/read"
done
