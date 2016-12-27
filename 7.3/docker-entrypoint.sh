#!/bin/bash

set -e

if [[ ! -z $DEBUG ]]; then
  set -x
fi

exec node
