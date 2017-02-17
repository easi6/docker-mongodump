#!/bin/bash

set -eo pipefail

declare -a versions=(
  edge
)

for version in "${versions[@]}"
do
  rm -rf "$version"
  cp -R base "$version"

  cat > "$version/Dockerfile" <<-END
# Generated automatically by update.sh
# Do no edit this file

FROM bigtruedata/dump:$version

RUN echo http://dl-4.alpinelinux.org/alpine/$version/testing >> /etc/apk/repositories \\
    && apk add --no-cache mongodb-tools

COPY mongodump-entrypoint /usr/local/bin/

VOLUME /dump
WORKDIR /dump

CMD ["mongodump-entrypoint"]
END

done
