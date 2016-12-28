#!/bin/bash

set -e

if [[ ! -z $DEBUG ]]; then
  set -x
fi

# Execute files in /docker-entrypoint-init.d
shopt -s nullglob

for f in /docker-entrypoint-init.d/*; do
    case "$f" in
        *.sh)   echo "$0: Running $f"; . "$f" ;;
        *)      echo "$0: Ignoring $f" ;;
    esac
    echo
done

exec node
