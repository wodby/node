#!/bin/bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

cleanup () {
    kill -s SIGTERM $!
    exit 0
}

init_volumes

if [[ "${1}" == "yarn" && ! -f "package.json" ]]; then
    echo "File package.json is missing in working dir ${PWD}"

    trap cleanup SIGINT SIGTERM

    while [ 1 ]; do
        sleep 60 &
        wait $!
    done
fi

exec "${@}"
