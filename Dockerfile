# check=skip=InvalidDefaultArgInFrom

# The Makefile supplies the required digest-pinned BASE_IMAGE argument.
ARG NODE_VER

ARG BASE_IMAGE
FROM ${BASE_IMAGE}

LABEL com.wodby.ci.cache="npm"

ARG NODE_DEV
ARG NPM_VERSION=11.19.1
ARG TARGETPLATFORM

ENV APP_ROOT="/usr/src/app" \
    FILES_DIR="/mnt/files" \
    NODE_PORT="3000" \
    NPM_CONFIG_PREFIX="/home/node/.npm-global"

ENV PATH="/home/node/.yarn/bin:${APP_ROOT}/node_modules/.bin:${NPM_CONFIG_PREFIX}/bin:${PATH}"

# Upgrade inherited packages even when their existing versions satisfy dependencies.
RUN set -ex; \
    apk upgrade --no-cache; \
    npm install --global --prefix /usr/local "npm@${NPM_VERSION}"; \
    npm cache clean --force; \
    \
    apk add --update \
        bash \
        ca-certificates \
        curl \
        git \
        make \
        wget \
        sudo; \
    \
    if [[ -n "${NODE_DEV}" ]]; then \
        apk add --update --no-cache -t .wodby-node-build-deps python3 g++; \
    fi; \
    \
    { \
        echo "Defaults secure_path=\"$PATH\""; \
        echo 'Defaults env_keep += "APP_ROOT FILES_DIR"' ; \
        if [[ -n "${NODE_DEV}" ]]; then \
            echo 'node ALL=(root) NOPASSWD:SETENV:ALL'; \
        else \
            echo 'node ALL=(root) NOPASSWD:SETENV: /usr/local/bin/init_volumes'; \
        fi; \
    } | tee /etc/sudoers.d/node; \
    \
    mkdir -p "${APP_ROOT}" "${FILES_DIR}"; \
    chown node:node "${APP_ROOT}" "${FILES_DIR}"; \
    \
    dockerplatform=${TARGETPLATFORM:-linux/amd64};\
    gotpl_url="https://github.com/wodby/gotpl/releases/latest/download/gotpl-${dockerplatform/\//-}.tar.gz"; \
    wget -qO- "${gotpl_url}" | tar xz --no-same-owner -C /usr/local/bin; \
    \
    echo "chown node:node ${FILES_DIR}" > /usr/local/bin/init_volumes; \
    chmod +x /usr/local/bin/init_volumes

WORKDIR ${APP_ROOT}

USER node

COPY docker-entrypoint.sh /
COPY bin /usr/local/bin/

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [ "node" ]
