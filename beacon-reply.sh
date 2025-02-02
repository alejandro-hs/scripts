#!/bin/bash

# Script to reply to a Beacon conversation using the Help Scout API
# Usage: ./beacon-reply.sh <device_id> <conversation_id>

# Configuration
API_URL="http://beacon-main-api.hs-stack.orb.local"
#API_URL="https://beaconapi.helpscout.net"  # Production URL (commented out)
EMAIL="cochee83@msn.com"
BEACON_ID="62ff60a9-6b49-442a-86b3-225da3d63f7a"

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

# Prepare JSON payload
JSON_PAYLOAD=$(cat <<EOF
{
    "text": "From device ${DEVICE_ID}, replying to convo ${CONVERSATION_ID}\n",
    "attachmentIds": []
}
EOF
)

# Reply to conversation
curl -s "${API_URL}/v1/${BEACON_ID}/conversations/${CONVERSATION_ID}/reply" \
    -H "Content-Type: application/json" \
    -H "Authorization: Beacon Email=${EMAIL},DeviceId=${DEVICE_ID}" \
    --data "$JSON_PAYLOAD" \
    | jq '.' \
    || {
        echo "Error: Failed to send reply to conversation"
        exit 1
    }
