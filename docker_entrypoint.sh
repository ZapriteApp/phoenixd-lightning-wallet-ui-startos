#!/bin/sh

printf "\n\n [i] Starting Phoenixd wallet application ...\n\n"

CONF_FILE="/root/.phoenix/phoenix.conf"


# Start the phoenixd daemon
if pgrep -x "phoenixd" > /dev/null; then
    echo "[i] phoenixd is already running as a dependency."
else
    echo "[i] Starting phoenixd daemon from the local binary..."
    /usr/local/bin/phoenixd &
    sleep 1
    if ! pgrep -x "phoenixd" > /dev/null; then
        echo "[ERROR] phoenixd failed to start."
        exit 1
    fi
    echo "[i] phoenixd started successfully."
fi

# Start the Node.js application
echo "Starting Node.js application..."
echo "PHOENIX_API_URL=http://127.0.0.1:9740" > /usr/src/app/backend/.env
cat /usr/src/app/backend/.env 
export RUST_BACKTRACE=1
exec node /usr/src/app/backend/server.js
