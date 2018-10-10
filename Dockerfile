ARG BASE_IMAGE_TAG

FROM node:${BASE_IMAGE_TAG}

ENV APP_ROOT="/usr/src/app" \
    FILES_DIR="/mnt/files" \
    NODE_PORT="3000"

ENV PATH="/home/node/.yarn/bin:${APP_ROOT}/node_modules/.bin:${PATH}"

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
    mkdir -p "${APP_ROOT}" "${FILES_DIR}"; \
    chown node:node "${APP_ROOT}" "${FILES_DIR}"; \
    \
    gotlp_ver="0.1.5"; \
    url="https://github.com/wodby/gotpl/releases/download/${gotlp_ver}/gotpl-alpine-linux-amd64-${gotlp_ver}.tar.gz"; \
    wget -qO- "${url}" | tar xz -C /usr/local/bin; \
    \
    echo "chown node:node ${APP_ROOT} ${FILES_DIR}" > /usr/local/bin/init_volumes; \
    chmod +x /usr/local/bin/init_volumes; \
    echo 'node ALL=(root) NOPASSWD:SETENV: /usr/local/bin/init_volumes' > /etc/sudoers.d/node

WORKDIR ${APP_ROOT}

USER node

COPY docker-entrypoint.sh /
COPY bin /usr/local/bin/

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [ "node" ]
