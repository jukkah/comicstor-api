-- depends_on: versions.sql

DO LANGUAGE plpgsql $wrapper$
BEGIN

  -- Drop roles if exists cascade
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname='comicstor_postgraphql') THEN
    DROP OWNED BY comicstor_postgraphql CASCADE;
    DROP ROLE comicstor_postgraphql;
  END IF;

  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname='comicstor_anonymous') THEN
    DROP OWNED BY comicstor_anonymous CASCADE;
    DROP ROLE comicstor_anonymous;
  END IF;

  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname='comicstor_user') THEN
    DROP OWNED BY comicstor_user CASCADE;
    DROP ROLE comicstor_user;
  END IF;

END;
$wrapper$;

-- Internal user for connecting from api to db
CREATE ROLE comicstor_postgraphql LOGIN PASSWORD 'xyz';

-- Anonymous user role
CREATE ROLE comicstor_anonymous;
GRANT comicstor_anonymous TO comicstor_postgraphql;

-- Authenticated user role
CREATE ROLE comicstor_user;
GRANT comicstor_user TO comicstor_postgraphql;
