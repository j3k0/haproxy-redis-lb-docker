#!/usr/bin/env bash

function globalHeader() {
cat << EOF
# Specifies TCP timeout on connect for use by the frontend ft_redis
# Set the max time to wait for a connection attempt to a server to succeed
# The server and client side expected to acknowledge or send data.
defaults REDIS
mode tcp
timeout connect 3s
timeout server 9s
timeout client 9s
timeout tunnel 7d
EOF
}

function serviceHeader() {
    PORT=$1
cat << EOF

# Specifies listening socket for accepting client connections using the default
# REDIS TCP timeout and backend bk_redis TCP health check.
frontend ft_redis_$PORT
bind *:$PORT name redis
default_backend bk_redis_$PORT

# Specifies the backend Redis proxy server TCP health settings
# Ensure it only forward incoming connections to reach a master.
backend bk_redis_$PORT
option tcp-check
tcp-check connect
tcp-check send PING\r\n
tcp-check expect string +PONG
tcp-check send info\ replication\r\n
tcp-check expect string role:master
tcp-check send QUIT\r\n
tcp-check expect string +OK
EOF
}

function serverDefinitions() {
  SERVERS=$1
  N=0
  for i in $SERVERS; do
    SERVER=(${i//:/ })
    SERVER_HOST=${SERVER[0]}
    SERVER_PORT=${SERVER[1]}
    if [ -z $SERVER_PORT ]; then SERVER_PORT=6379; fi
    ((N++))
    echo "server s$N $SERVER_HOST:$SERVER_PORT check inter 1s"
  done
}

function serversList() {
    for URL in $@; do
        echo "curl -s $URL | python app-tasks.py" 1>&2
        curl -s $URL | python "`dirname $0`/app-tasks.py"
    done
}

function reloadConfig() {
    echo "Reloading config..."
    echo ">>>>>>>>>> FILE START: /etc/haproxy.cfg"
    cat /etc/haproxy.cfg
    echo "<<<<<<<<<< FILE END:   /etc/haproxy.cfg"
    killall -HUP haproxy-systemd-wrapper
}

function makeConfig() {
  globalHeader
  for i in $1; do
    PORT=`echo $i | cut -d: -f1`
    URLS=`echo $i | cut -d: -f2- | sed 's/,/ /g'`
    serviceHeader $PORT
    SERVERS=`serversList "$URLS" | sort | uniq`
    serverDefinitions "$SERVERS"
  done
}

# CLI option `--dry-run` allows to test the serverDefinitions() method.
if [ "_$1" = "_--dry-run" ]; then
  shift
  makeConfig "$@"
else
  CONFIG="$@"
  makeConfig "$CONFIG" > /etc/haproxy.cfg
  /docker-entrypoint.sh haproxy -f /etc/haproxy.cfg &
  while true; do
    sleep 10
    makeConfig "$CONFIG" > /etc/haproxy.cfg.new
    if ! diff -q /etc/haproxy.cfg /etc/haproxy.cfg.new; then
        cp /etc/haproxy.cfg.new /etc/haproxy.cfg
        reloadConfig
    fi
  done
fi

