# haproxy redis-lb

Forward redis traffic to the redis master.

#### Usage

```
docker run -d -p 6379:6379 jeko/haproxy-redis-lb:latest "192.168.0.2:6379;192.168.0.2:6380;192.168.0.3;192.168.0.4:4021"
```

Argument is a semicolon (;) separated list of servers. Format: `host[:port];host[:port]...`

Each server is defined by its address (or hostname) and optional port (default: 6379).

#### Details

You want your clients to connect to a single "HOST:PORT" to access redis? This haproxy setup will let you do just that, by detecting which instance is configured as master and route traffic to it.

You will need the help an external tool (probably redis-sentinel) to control your master and replicas.

More details here about this concept and implementation: https://discuss.pivotal.io/hc/en-us/articles/205309388-How-to-setup-HAProxy-and-Redis-Sentinel-for-automatic-failover-between-Redis-Master-and-Slave-servers

#### Note

This fork of [QuantumIOT/haproxy-redis-lb-docker](https://github.com/QuantumIOT/haproxy-redis-lb-docker) allows to specify redis servers ports.
