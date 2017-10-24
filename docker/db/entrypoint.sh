#!/bin/sh

/usr/local/bin/docker-entrypoint.sh postgres &

while ! pg_isready -h db -U postgres -q > /dev/null 2> /dev/null; do
    sleep 1
done

set -e

sh /code/load-schema.sh

wait
