#!/bin/sh

printf "\n\n [i] Starting Phoenixd wallet application ...\n\n"

CONF_FILE="/root/.phoenix/phoenix.conf"
ENV_FILE="/usr/src/app/.env"

# Set the PHOENIX_API_URL in the environment file
echo "PHOENIX_API_URL=http://127.0.0.1:9740" >> $ENV_FILE
echo "Values copied to $ENV_FILE."

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
cat /usr/src/app/.env 
export RUST_BACKTRACE=1
exec node /usr/src/app/server.js
