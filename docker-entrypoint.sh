#!/bin/bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

exec_init_scripts() {
    shopt -s nullglob
    for f in /docker-entrypoint-init.d/*; do
        . "$f"
    done
    shopt -u nullglob
}

cleanup () {
    kill -s SIGTERM $!
    exit 0
}

init_volumes
exec_init_scripts

if [[ "${1}" == "yarn" && ! -f "package.json" ]]; then
    echo "File package.json is missing in working dir ${PWD}"

    trap cleanup SIGINT SIGTERM

    while [ 1 ]; do
        sleep 60 &
        wait $!
    done
fi

if [[ "${1}" == 'make' ]]; then
    exec "${@}" -f /usr/local/bin/actions.mk
else
    exec "${@}"
fi
