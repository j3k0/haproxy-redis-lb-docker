#!/dumb-init /bin/sh

# Launch haproxy-configurator,
# whose role is to refresh /etc/haproxy.cfg and reload haproxy when it changes.
/haproxy-configurator.sh "$@" &

# Wait for a minimal valid config (created by haproxy-configurator at startup)
while [ ! -e /etc/haproxy.cfg ]; do
    sleep 0.1
done

# Then launch haproxy
/docker-entrypoint.sh haproxy -f /etc/haproxy.cfg
