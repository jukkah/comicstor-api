-- depends_on: types.sql

CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO LANGUAGE plpgsql $wrapper$
BEGIN

  IF NOT _v.is_executed('user_management.sql', 'initial-version') THEN
    PERFORM _v.set_executed('user_management.sql', 'initial-version');

    -- Public part of table for user account
    CREATE TABLE comicstor.user (
      -- User id
      id SERIAL PRIMARY KEY,
      -- User's name for better debugging
      name CHARACTER VARYING(20) NOT NULL
    );

    GRANT SELECT ON TABLE comicstor.user TO comicstor_anonymous, comicstor_user;
    GRANT UPDATE, DELETE ON TABLE comicstor.user TO comicstor_user;
    ALTER TABLE comicstor.user ENABLE ROW LEVEL SECURITY;

    -- Private part of table for user account
    CREATE TABLE comicstor_private.user_account (
      user_id  INTEGER PRIMARY KEY REFERENCES comicstor.user (id) ON DELETE CASCADE,
      email CHARACTER VARYING(254) NOT NULL UNIQUE CHECK (email ~* '^.+@.+\..+$'),
      password_hash CHARACTER(60) NOT NULL
    );

  END IF;

END;
$wrapper$;

--------------------------------------------------------------------------------

-- Register new user
DROP FUNCTION IF EXISTS comicstor.register( TEXT, TEXT, TEXT ) CASCADE;
CREATE FUNCTION comicstor.register(
  name     TEXT,
  email    TEXT,
  password TEXT
) RETURNS comicstor.user AS $$
DECLARE
  _user comicstor.user;
BEGIN
  INSERT INTO comicstor.user (name) VALUES (register.name)
  RETURNING * INTO _user;

  INSERT INTO comicstor_private.user_account (user_id, email, password_hash)
  VALUES (_user.id, register.email, crypt(register.password, gen_salt('bf')));

  RETURN _user;
END;
$$ LANGUAGE plpgsql STRICT SECURITY DEFINER VOLATILE;

GRANT EXECUTE ON FUNCTION comicstor.register(TEXT, TEXT, TEXT) TO comicstor_anonymous;

--------------------------------------------------------------------------------

-- Authenticate user
DROP FUNCTION IF EXISTS comicstor.authenticate( TEXT, TEXT ) CASCADE;
CREATE FUNCTION comicstor.authenticate(
  email    TEXT,
  password TEXT
) RETURNS comicstor.JWT_TOKEN AS $$
DECLARE
  _account comicstor_private.user_account;
BEGIN
  SELECT *
  INTO _account
  FROM comicstor_private.user_account
  WHERE comicstor_private.user_account.email = authenticate.email;

  IF _account.password_hash = crypt(authenticate.password, _account.password_hash)
  THEN
    RETURN ('comicstor_user', _account.user_id) :: comicstor.JWT_TOKEN;
  ELSE
    RETURN NULL;
  END IF;
END;
$$ LANGUAGE plpgsql STRICT SECURITY DEFINER STABLE;

GRANT EXECUTE ON FUNCTION comicstor.authenticate(TEXT, TEXT) TO comicstor_anonymous, comicstor_user;

--------------------------------------------------------------------------------

-- Get current user id
DROP FUNCTION IF EXISTS comicstor.current_user_id() CASCADE;
CREATE FUNCTION comicstor.current_user_id() RETURNS INTEGER AS $$
  SELECT current_setting('jwt.claims.user_id', TRUE) :: INTEGER
$$ LANGUAGE SQL STABLE;

GRANT EXECUTE ON FUNCTION comicstor.current_user_id() TO comicstor_anonymous, comicstor_user;

--------------------------------------------------------------------------------

-- Get current user
DROP FUNCTION IF EXISTS comicstor.current_user() CASCADE;
CREATE FUNCTION comicstor.current_user() RETURNS comicstor.user AS $$
  SELECT *
  FROM comicstor.user
  WHERE id = comicstor.current_user_id()
$$ LANGUAGE SQL STABLE;

GRANT EXECUTE ON FUNCTION comicstor.current_user() TO comicstor_anonymous, comicstor_user;

--------------------------------------------------------------------------------

DROP POLICY IF EXISTS select_user ON comicstor.user;
CREATE POLICY select_user
ON comicstor.user FOR SELECT
USING (TRUE);

DROP POLICY IF EXISTS update_user ON comicstor.user;
CREATE POLICY update_user
ON comicstor.user FOR UPDATE TO comicstor_user
USING (id = comicstor.current_user_id())
WITH CHECK (id = comicstor.current_user_id());

DROP POLICY IF EXISTS delete_user ON comicstor.user;
CREATE POLICY delete_user
ON comicstor.user FOR DELETE TO comicstor_user
USING (id = comicstor.current_user_id());
