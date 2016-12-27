#!/bin/bash

set -e

if [[ ! -z $DEBUG ]]; then
  set -x
fi

if [[ ! -z $WWW_DATA_GID && ! -z $WWW_DATA_UID ]]; then
    deluser www-data
    addgroup -g $WWW_DATA_GID -S www-data
    adduser -u $WWW_DATA_UID -D -S -G www-data www-data
fi

exec node
