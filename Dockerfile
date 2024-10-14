ARG NODE_VER

FROM node:${NODE_VER}-alpine

ARG NODE_DEV
ARG TARGETPLATFORM

ENV APP_ROOT="/usr/src/app" \
    FILES_DIR="/mnt/files" \
    NODE_PORT="3000" \
    NPM_CONFIG_PREFIX="/home/node/.npm-global"

ENV PATH="/home/node/.yarn/bin:${APP_ROOT}/node_modules/.bin:${NPM_CONFIG_PREFIX}/bin:${PATH}"

RUN set -ex; \
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
        echo 'Defaults env_keep += "APP_ROOT FILES_DIR"' ; \
        if [[ -n "${NODE_DEV}" ]]; then \
            echo 'node ALL=(root) NOPASSWD:SETENV:ALL'; \
        else \
            echo 'node ALL=(root) NOPASSWD:SETENV: /usr/local/bin/init_volumes' > /etc/sudoers.d/node; \
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
    echo "chown node:node ${APP_ROOT} ${FILES_DIR}" > /usr/local/bin/init_volumes; \
    chmod +x /usr/local/bin/init_volumes

WORKDIR ${APP_ROOT}

USER node

COPY docker-entrypoint.sh /
COPY bin /usr/local/bin/

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [ "node" ]
