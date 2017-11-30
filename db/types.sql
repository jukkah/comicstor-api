-- depends_on: schemas.sql

DO LANGUAGE plpgsql $wrapper$
BEGIN

  IF NOT _v.is_executed('types.sql', 'initial-version') THEN
    PERFORM _v.set_executed('types.sql', 'initial-version');

    -- Money type
    create type comicstor.price as (
      currency character(3),
      amount numeric(10,2)
    );

    -- Elastic date type
    create type comicstor.date as (
      year smallint,
      month smallint,
      day smallint
    );

    -- jwt_token was originally created in initial-version of user_management.sql
    IF NOT _v.is_executed('user_management.sql', 'initial-version') THEN
      -- JWT token type used in authentication
      CREATE TYPE comicstor.JWT_TOKEN AS (
        role TEXT,
        user_id INTEGER
      );
    END IF;

  END IF;

END;
$wrapper$;
