#!/bin/bash

# Script to fetch Beacon conversations using the Help Scout API
# Usage: ./beacon-convos.sh <device_id>

source .env

# Validate input arguments
if [ $# -eq 0 ]; then
    echo "Error: Device ID is required"
    echo "Usage: $0 <device_id>"
    echo "Example: $0 5bcc8913-3a75-463a-9161-9acb4bc24c39"
    exit 1
fi

DEVICE_ID="$1"

# Validate device ID format (basic UUID check)
if ! [[ $DEVICE_ID =~ ^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$ ]]; then
    echo "Error: Invalid device ID format. Must be a valid UUID."
    exit 1
fi

# Fetch conversations
curl -s "${API_URL}/v1/${BEACON_ID}/conversations" \
    -H "Authorization: Beacon Email=${EMAIL},DeviceId=${DEVICE_ID}" \
    | jq -c -r '.items[] | [.id, .firstThread.createdAt, .lastThread.createdAt, .subject] | @tsv' \
    | sort -n -r \
    || {
        echo "Error: Failed to fetch conversations"
        exit 1
    }
