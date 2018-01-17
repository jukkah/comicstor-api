const http = require('http');
const { postgraphql } = require('postgraphql');

http.createServer(
    postgraphql(
        process.env.DATABASE_URL,
        'comicstor',
        {
            pgDefaultRole: 'comicstor_anonymous',
            graphiql: true,
            jwtSecret: 'keyboard_kitten',
            jwtPgTypeIdentifier: 'comicstor.jwt_token',
            disableQueryLog: process.env.NODE_ENV === 'production',
        },
    )
).listen(process.env.PORT);
