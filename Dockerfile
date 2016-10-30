FROM haproxy:1.6-alpine

# Install bash python curl
RUN apk add --no-cache bash

COPY redis-lb-entrypoint /redis-lb-entrypoint
COPY redis-lb-configurator /redis-lb-configurator

ENV BIND_ADDRESS 0.0.0.0

ENTRYPOINT [ "/redis-lb-entrypoint" ]
