ARG BASE_IMAGE_TAG

FROM node:${BASE_IMAGE_TAG}

ENV APP_ROOT="/usr/src/app" \
    FILES_DIR="/mnt/files" \
    PATH="/home/node/.yarn/bin:$PATH" \
    GOTLP_VER="0.1.5" \
    NODE_PORT="3000"

RUN set -ex; \
    \
    apk add --update \
        bash \
        ca-certificates \
        curl \
        make \
        wget \
        sudo; \
    \
    mkdir -p "${APP_ROOT}" "${FILES_DIR}"; \
    chown node:node "${APP_ROOT}" "${FILES_DIR}"; \
    \
    url="https://github.com/wodby/gotpl/releases/download/${GOTLP_VER}/gotpl-alpine-linux-amd64-${GOTLP_VER}.tar.gz"; \
    wget -qO- "${url}" | tar xz -C /usr/local/bin; \
    \
    echo "chown node:node ${APP_ROOT} ${FILES_DIR}" > /usr/local/bin/init_volumes; \
    chmod +x /usr/local/bin/init_volumes; \
    echo 'node ALL=(root) NOPASSWD:SETENV: /usr/local/bin/init_volumes' > /etc/sudoers.d/node

WORKDIR ${APP_ROOT}

USER node

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [ "node" ]