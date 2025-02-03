#!/bin/bash

# Script to fetch Beacon customer using the Help Scout API
# Usage: ./beacon-customers.sh

source .env

# Fetch customer and format output
curl -s "${CORE_API_URL}/v1/beacon/${BEACON_ID}/customers?email=${EMAIL}" \
    | jq \
    || {
        echo "Error: Failed to fetch customer"
        exit 1
    }
