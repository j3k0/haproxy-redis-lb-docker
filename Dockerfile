FROM haproxy:alpine

RUN apk add --no-cache bash

COPY haproxy.cfg /haproxy.cfg
COPY haproxy-redis-lb-entrypoint.sh /haproxy-redis-lb-entrypoint.sh

EXPOSE 6379

ENTRYPOINT [ "/haproxy-redis-lb-entrypoint.sh" ]
