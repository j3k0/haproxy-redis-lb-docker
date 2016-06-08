FROM haproxy:alpine

RUN apk add --no-cache bash

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY haproxy-redis-lb-init.sh /usr/local/bin/haproxy-redis-lb-init.sh

EXPOSE 9092

ENTRYPOINT [ "/usr/local/bin/haproxy-redis-lb-init.sh" ]