#!/bin/bash

# Scenario: You have a Nextcloud news account for video RSS feeds. You want to
# download everything unread using youtube-dl.

# Source .env
set -o allexport
source .env
set +o allexport

# -f for non-2xx/3xx codes as errors
# -sS for disabling progress meter
# -L follow redirects
# URL fetches unread articles from all feeds
return_data=$( curl \
    -f \
    -Ss \
    -L \
    -X GET \
    --user "$USERNAME:$PASSWORD" \
    -H "Accept: \"application/json\"" \
    "$BASE_URL/apps/news/api/v1-2/items?type=3&getRead=false&batchSize=-1" )

# -r to remove quotes (raw-output)
urls_string=$( jq -r '.items[].url' <(echo "$return_data") )
ids_string=$( jq -r '.items[].id' <(echo "$return_data") )

while read -r line; do urls+=("$line"); done <<<"$urls_string"
while read -r line; do ids+=("$line"); done <<<"$ids_string"

pushd "$OUTPUT_DIR" || exit

for ((i = 0; i < ${#urls[@]}; ++i)); do
    url="${urls[$i]}"
    id="${ids[$i]}"
    if ! youtube-dl -q -f mp4 "$url"; then
        echo "$url" >> "$FAILED_FILE"
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
