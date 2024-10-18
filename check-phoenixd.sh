#!/bin/bash

DURATION=$(</dev/stdin)
if (($DURATION <= 30000)); then
    echo "Service is still initializing"
    exit 60
else
    # Check if the Phoenixd daemon is running
    if pgrep -x "phoenixd" > /dev/null; then
        echo "Phoenixd service is running and healthy"
        exit 0
    else
        echo "Phoenixd service is not running" >&2
        exit 1
    fi
fi


