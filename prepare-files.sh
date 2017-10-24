#!/bin/sh

set -e

FILES="$@"
for f in $FILES
do
    FILENAME=$(echo "$f" | grep -ioE "\w+\.sql")
    echo "$FILENAME $FILENAME"

    DEPS=$(grep -i "^-- depends_on:" $f | grep -ioE "\w+\.sql")

    for DEP in $DEPS
    do
        echo "$FILENAME $DEP"
    done
done
