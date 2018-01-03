#!/bin/sh

while ! pg_isready -h db -U postgres -q > /dev/null 2> /dev/null; do
    sleep 1
done

sh start-api.sh
