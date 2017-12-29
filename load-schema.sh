#!/bin/sh

set -e

DIR="$(pwd)/db"
FILES=$(sh prepare-files.sh $DIR/*.sql | tsort | tac)

TRANSACTION=""

for FILE in $FILES
do
    TRANSACTION="$TRANSACTION $(cat $DIR/$FILE)"
done

psql -q -v ON_ERROR_STOP=1 -U postgres -d postgres <<EOF
    BEGIN;
    SET local client_min_messages TO WARNING;
    $TRANSACTION
    COMMIT;
EOF

echo "Database schema updated successfully"
