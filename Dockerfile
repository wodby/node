ARG BASE_IMAGE_TAG

FROM node:${BASE_IMAGE_TAG}

ENV APP_ROOT="/usr/src/app" \
    FILES_DIR="/mnt/files"

RUN set -ex; \
    apk add --update bash sudo; \
    \
    mkdir -p "${APP_ROOT}" "${FILES_DIR}"; \
    chown node:node "${APP_ROOT}" "${FILES_DIR}"; \
    \
    echo "chown node:node ${APP_ROOT} ${FILES_DIR}" > /usr/local/bin/init_volumes; \
    chmod +x /usr/local/bin/init_volumes; \
    echo 'node ALL=(root) NOPASSWD:SETENV: /usr/local/bin/init_volumes' > /etc/sudoers.d/node

WORKDIR ${APP_ROOT}

USER node

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [ "node" ]