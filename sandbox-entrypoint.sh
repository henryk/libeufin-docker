#!/usr/bin/env bash

if [ "$1" = 'serve' ]; then
  echo Initializing demo bank
  libeufin-sandbox config --show default 2>&1 | grep -v 'Nothing to show' || (
    libeufin-sandbox config --currency EUR default; libeufin-sandbox config --show default
  )
fi

exec libeufin-sandbox "$@"
