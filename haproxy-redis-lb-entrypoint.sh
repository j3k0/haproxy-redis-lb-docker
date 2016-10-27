#!/usr/bin/env bash

function serverDefinitions() {
  SERVERS=$1
  SERVERS=(${SERVERS//;/ })
  N=0
  for i in "${SERVERS[@]}"; do
    SERVER=(${i//:/ })
    SERVER_HOST=${SERVER[0]}
    SERVER_PORT=${SERVER[1]}
    if [ -z $SERVER_PORT ]; then SERVER_PORT=6379; fi
    ((N++))
    echo "server server$N $SERVER_HOST:$SERVER_PORT check inter 1s"
  done
}

# CLI option `--dry-run` allows to test the serverDefinitions() method.
if [ "_$1" = "_--dry-run" ]; then
  serverDefinitions "$2"
  exit 0
fi

cp /haproxy.cfg /etc/haproxy.cfg
serverDefinitions "$1" >> /etc/haproxy.cfg
/docker-entrypoint.sh haproxy -f /etc/haproxy.cfg
