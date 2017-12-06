-- depends_on: user_management.sql

DO LANGUAGE plpgsql $wrapper$
BEGIN

  IF NOT _v.is_executed('collection.sql', 'initial-version') THEN
    PERFORM _v.set_executed('collection.sql', 'initial-version');

    CREATE TABLE comicstor.collection (
      id SERIAL PRIMARY KEY,
      name CHARACTER VARYING(20) NOT NULL,
      owner_id INTEGER NOT NULL REFERENCES comicstor.user (id) ON DELETE CASCADE
    );

  END IF;

END;
$wrapper$;

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE comicstor.collection TO comicstor_user;
GRANT USAGE ON SEQUENCE comicstor.collection_id_seq TO comicstor_user;
ALTER TABLE comicstor.collection ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS all_collection ON comicstor.collection;
CREATE POLICY all_collection
ON comicstor.collection FOR ALL TO comicstor_user
USING (owner_id = comicstor.current_user_id())
WITH CHECK (owner_id = comicstor.current_user_id());
