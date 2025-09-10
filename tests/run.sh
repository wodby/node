#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

cid="$(docker run -d -e DEBUG -v ./app.js:/usr/src/app/app.js --name "${NAME}" "${IMAGE}" -- node app.js)"
trap "docker rm -vf $cid > /dev/null" EXIT

node() {
	docker run --rm -i -e DEBUG --link "${NAME}" "${IMAGE}" "${@}"
}

node make check-ready max_try=10 host="${NAME}"

echo -n "Checking Node version... "
node node --version | grep -q "v${NODE_VER}"
echo "OK"
