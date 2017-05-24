FROM chiaen/docker-gcsfuse:latest

Run set -ex \
    && apk add --no-cache --virtual .redis redis \ 
    && cp $(which redis-cli) /usr/local/bin \
    && apk del .redis

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --no-cache twemproxy && rm -rf /tmp/*

