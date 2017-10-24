-- depends_on: versions.sql

DO LANGUAGE plpgsql $wrapper$
BEGIN

  IF NOT _v.is_executed('roles.sql', 'initial-version') THEN
    PERFORM _v.set_executed('roles.sql', 'initial-version');

    -- Internal user for connecting from api to db
    CREATE ROLE comicstor_postgraphql LOGIN PASSWORD 'xyz';

    -- Anonymous user role
    CREATE ROLE comicstor_anonymous;
    GRANT comicstor_anonymous TO comicstor_postgraphql;

    -- Authenticated user role
    CREATE ROLE comicstor_user;
    GRANT comicstor_user TO comicstor_postgraphql;

  END IF;

END;
$wrapper$;
