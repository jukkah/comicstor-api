-- depends_on: versions.sql

-- Internal user for connecting from api to db
DROP OWNED BY comicstor_postgraphql CASCADE;
DROP ROLE IF EXISTS comicstor_postgraphql;
CREATE ROLE comicstor_postgraphql LOGIN PASSWORD 'xyz';

-- Anonymous user role
DROP OWNED BY comicstor_anonymous CASCADE;
DROP ROLE IF EXISTS comicstor_anonymous;
CREATE ROLE comicstor_anonymous;

-- Authenticated user role
DROP OWNED BY comicstor_user CASCADE;
DROP ROLE IF EXISTS comicstor_user;
CREATE ROLE comicstor_user;

GRANT comicstor_anonymous TO comicstor_postgraphql;
GRANT comicstor_user TO comicstor_postgraphql;
