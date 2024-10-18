#!/bin/bash

DURATION=$(</dev/stdin)
if (($DURATION <= 30000)); then
    echo "Service is still initializing"
    exit 60
else
    # Check if the Phoenixd service and Node.js app are running inside the container
    if curl --silent --fail http://127.0.0.1:3000 &>/dev/null; then
        echo "Service is healthy"
        exit 0
    else
        echo "Service is unreachable inside the container" >&2
        exit 1
    fi
fi

