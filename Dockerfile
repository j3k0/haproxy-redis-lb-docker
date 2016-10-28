FROM haproxy:1.6-alpine

RUN apk add --no-cache bash python curl

COPY app-tasks.py /app-tasks.py
COPY haproxy-redis-lb-entrypoint.sh /haproxy-redis-lb-entrypoint.sh

ENTRYPOINT [ "/haproxy-redis-lb-entrypoint.sh" ]
