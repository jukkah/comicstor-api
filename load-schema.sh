#!/bin/sh

set -e

DIR="$(pwd)/db"
FILES=$(sh prepare-files.sh $DIR/*.sql | tsort | tac)

TRANSACTION=""

for FILE in $FILES
do
    TRANSACTION="$TRANSACTION $(cat $DIR/$FILE)"
done

echo "
    BEGIN;
    SET local client_min_messages TO WARNING;
    $TRANSACTION
    COMMIT;
" > /tmp/import.sql

node import.js

rm /tmp/import.sql

echo "Database schema updated successfully"
