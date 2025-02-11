#!/bin/bash

# Script to fetch a Beacon conversation using the Help Scout API
# Usage: ./beacon-conversation.sh <device_id> <conversation_id>

source .env

# Validate input arguments
if [ $# -ne 2 ]; then
    echo "Error: Both device ID and conversation ID are required"
    echo "Usage: $0 <device_id> <conversation_id>"
    echo "Example: $0 c2bc8ed5-370b-44e0-b99a-6ed3cba3b05b 281796270"
    exit 1
fi

DEVICE_ID="$1"
CONVERSATION_ID="$2"

# Validate device ID format (basic UUID check)
if ! [[ $DEVICE_ID =~ ^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$ ]]; then
    echo "Error: Invalid device ID format. Must be a valid UUID."
    exit 1
fi

# Validate conversation ID
if ! [[ $CONVERSATION_ID =~ ^[0-9]+$ ]]; then
    echo "Error: Invalid conversation ID. Must be a valid integer."
    exit 1
fi

# Define column headers
readonly HEADERS=("created_by" "created_at" "body")
readonly FORMAT="%-15s\t%-25s\t%-25s\t\n"

# Print headers
printf "$FORMAT" "${HEADERS[@]}"

# Fetch conversation and format output
response=$(curl -s -S "${API_URL}/v1/${BEACON_ID}/conversations/${CONVERSATION_ID}" \
    -H "Authorization: Beacon Email=${EMAIL},DeviceId=${DEVICE_ID}" 2>&1)

if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch conversation"
    echo "Curl error: $response"
    exit 1
fi

echo "$response" | jq -c -r '.threads[] | [.createdBy.type, .createdAt, .body] | @tsv' \
    | awk -v fmt="$FORMAT" -F'\t' '{printf fmt,$1,$2,$3}' \
    || {
        echo "Error: Failed to parse response"
        echo "Response: $response"
        exit 1
    }
