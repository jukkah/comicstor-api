FROM postgraphql/postgraphql

WORKDIR /

RUN apk add --update curl postgresql

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
