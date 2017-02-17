# Generated automatically by update.sh
# Do no edit this file

FROM bigtruedata/dump:edge

RUN echo http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
    && apk add --no-cache mongodb-tools

COPY mongodump-entrypoint /usr/local/bin/

VOLUME /dump
WORKDIR /dump

CMD ["mongodump-entrypoint"]
