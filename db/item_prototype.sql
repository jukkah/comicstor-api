-- depends_on: collection.sql

DO LANGUAGE plpgsql $wrapper$
BEGIN

  IF NOT _v.is_executed('item_prototype.sql', 'initial-version') THEN
    PERFORM _v.set_executed('item_prototype.sql', 'initial-version');

    CREATE TABLE comicstor.item_prototype (
      id  SERIAL PRIMARY KEY,
      number CHARACTER VARYING(10),
      published comicstor.date,
      original_price comicstor.price NOT NULL,
      collection_id INTEGER NOT NULL REFERENCES comicstor.collection (id) ON DELETE CASCADE
    );

    GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE comicstor.item_prototype TO comicstor_user;
    ALTER TABLE comicstor.item_prototype ENABLE ROW LEVEL SECURITY;

  END IF;

END;
$wrapper$;

DROP POLICY IF EXISTS all_item_prototype ON comicstor.item_prototype;
CREATE POLICY all_item_prototype
ON comicstor.item_prototype FOR ALL TO comicstor_user
USING (
  EXISTS(
    SELECT 1
    FROM comicstor.collection c
    WHERE c.id = collection_id
      AND c.owner_id = comicstor.current_user_id()
  )
)
WITH CHECK (
  EXISTS(
    SELECT 1
    FROM comicstor.collection c
    WHERE c.id = collection_id
      AND c.owner_id = comicstor.current_user_id()
  )
);
