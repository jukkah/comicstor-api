#!/bin/sh

while ! pg_isready -h db -U postgres -q > /dev/null 2> /dev/null; do
    sleep 1
done

postgraphql \
    -n 0.0.0.0 \
    --connection postgres://postgres:example@db:5432/postgres \
    --schema comicstor \
    --default-role comicstor_anonymous \
    --secret keyboard_kitten \
    --token comicstor.jwt_token \
    --watch
