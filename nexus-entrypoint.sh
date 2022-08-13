#!/usr/bin/env bash

if [ "$1" = 'sh' ]; then
  exec "$@"
elif [ "$1" = 'bash' ]; then
  exec "$@"
elif [ "$1" = 'libeufin-cli' ]; then
  exec "$@"
fi

exec libeufin-nexus "$@"
