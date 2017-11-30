-- depends_on: item_prototype.sql

DO LANGUAGE plpgsql $wrapper$
BEGIN

  IF NOT _v.is_executed('item.sql', 'initial-version') THEN
    PERFORM _v.set_executed('item.sql', 'initial-version');

    CREATE TABLE comicstor.item (
      id SERIAL PRIMARY KEY ,
      price comicstor.price NOT NULL,
      condition NUMERIC(3,1),
      tags CHARACTER VARYING(20)[],
      item_prototype_id INTEGER NOT NULL REFERENCES comicstor.item_prototype (id) ON DELETE CASCADE
    );

    GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE comicstor.item TO comicstor_user;
    ALTER TABLE comicstor.item ENABLE ROW LEVEL SECURITY;

  END IF;

END;
$wrapper$;

DROP POLICY IF EXISTS all_item ON comicstor.item;
CREATE POLICY all_item
ON comicstor.item FOR ALL TO comicstor_user
USING (
  EXISTS(
    SELECT 1
    FROM comicstor.item_prototype p
    LEFT JOIN comicstor.collection c on p.collection_id = c.id
    WHERE p.id = item_prototype_id
      AND c.owner_id = comicstor.current_user_id()
  )
)
WITH CHECK (
  EXISTS(
    SELECT 1
    FROM comicstor.item_prototype p
    LEFT JOIN comicstor.collection c on p.collection_id = c.id
    WHERE p.id = item_prototype_id
      AND c.owner_id = comicstor.current_user_id()
  )
);
