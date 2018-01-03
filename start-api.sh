#!/bin/sh

postgraphql \
    -n 0.0.0.0 \
    --connection ${DATABASE_URL} \
    --schema comicstor \
    --default-role comicstor_anonymous \
    --secret keyboard_kitten \
    --token comicstor.jwt_token \
    --watch
