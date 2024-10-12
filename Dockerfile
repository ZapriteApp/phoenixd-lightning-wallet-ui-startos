FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y curl \
    wget \
    unzip \
    procps \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY /phoenixd-lightning-wallet/package*.json ./

RUN npm install

COPY /phoenixd-lightning-wallet/ .

RUN touch .env

RUN wget https://github.com/ACINQ/phoenixd/releases/download/v0.3.3/phoenix-0.3.3-linux-x64.zip \
    && unzip -j phoenix-0.3.3-linux-x64.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/phoenixd \
    && rm phoenix-0.3.3-linux-x64.zip

COPY ./docker_entrypoint.sh  /usr/local/bin/docker_entrypoint.sh

RUN chmod 755 /usr/local/bin/docker_entrypoint.sh

EXPOSE 3000

# ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
