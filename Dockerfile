FROM debian:bullseye-slim

# Install required system packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    procps \
    supervisor

# Install Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /usr/src/app

# Copy package files and install backend dependencies
COPY /phoenix-server-wallet/backend/package*.json ./backend/
RUN cd backend && npm install

# Copy package files and install frontend dependencies
COPY /phoenix-server-wallet/client/package*.json ./client/
RUN cd client && npm install

# Set OpenSSL legacy provider to prevent Webpack errors in newer Node versions
ENV NODE_OPTIONS=--openssl-legacy-provider

# Copy the rest of the project
COPY /phoenix-server-wallet/ .

# Build frontend
RUN cd client && npm run build

# Download and install phoenixd daemon
RUN wget https://github.com/ACINQ/phoenixd/releases/download/v0.4.2/phoenix-0.4.2-linux-x64.zip \
    && unzip -j phoenix-0.4.2-linux-x64.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/phoenixd \
    && rm phoenix-0.4.2-linux-x64.zip


# Entrypoint and helper scripts
COPY ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
COPY ./check-phoenixd.sh /usr/local/bin/check-phoenixd.sh
COPY ./check-ui.sh /usr/local/bin/check-ui.sh

RUN chmod 755 /usr/local/bin/docker_entrypoint.sh \
    && chmod +x /usr/local/bin/check-phoenixd.sh \
    && chmod +x /usr/local/bin/check-ui.sh

# Expose backend port
EXPOSE 32400

# Start the app
CMD ["docker_entrypoint.sh"]


# ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
