-- depends_on: versions.sql

DO LANGUAGE plpgsql $wrapper$
BEGIN

  -- Internal user for connecting from api to db
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='comicstor_postgraphql') THEN
    CREATE ROLE comicstor_postgraphql LOGIN PASSWORD 'xyz';
  ELSE
    ALTER ROLE comicstor_postgraphql LOGIN PASSWORD 'xyz';
  END IF;

  -- Anonymous user role
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='comicstor_anonymous') THEN
    CREATE ROLE comicstor_anonymous;
    GRANT comicstor_anonymous TO comicstor_postgraphql;
  END IF;

  -- Authenticated user role
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='comicstor_user') THEN
    CREATE ROLE comicstor_user;
    GRANT comicstor_user TO comicstor_postgraphql;
  END IF;

END;
$wrapper$;
