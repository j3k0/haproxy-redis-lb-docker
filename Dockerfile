FROM haproxy:1.6-alpine

# Install bash python curl
RUN apk add --no-cache bash python curl

# Install dumb-init
RUN curl -L https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 > /dumb-init
RUN chmod +x /dumb-init

COPY haproxy-redis-lb-entrypoint.sh /haproxy-redis-lb-entrypoint.sh
COPY app-tasks.py /app-tasks.py
COPY haproxy-configurator.sh /haproxy-configurator.sh

ENTRYPOINT [ "/dumb-init", "--", "/haproxy-redis-lb-entrypoint.sh" ]
