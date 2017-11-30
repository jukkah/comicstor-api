-- depends_on: roles.sql

DO LANGUAGE plpgsql $wrapper$
BEGIN

  IF NOT _v.is_executed('schemas.sql', 'initial-version') THEN
    PERFORM _v.set_executed('schemas.sql', 'initial-version');

    -- Schema for private part of comicstor
    CREATE SCHEMA comicstor_private;

    -- Schema for public part of comicstor
    CREATE SCHEMA comicstor;

    GRANT USAGE ON SCHEMA comicstor TO comicstor_anonymous, comicstor_user;

  END IF;

END;
$wrapper$;
