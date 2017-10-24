BEGIN;

SET SEARCH_PATH TO public;

CREATE EXTENSION pgtap;

SELECT no_plan();

-- schema comicstor is public
SELECT has_schema('comicstor');
SELECT schema_privs_are('comicstor', 'comicstor_postgraphql', ARRAY ['USAGE']);
SELECT schema_privs_are('comicstor', 'comicstor_anonymous', ARRAY ['USAGE']);
SELECT schema_privs_are('comicstor', 'comicstor_user', ARRAY ['USAGE']);

-- schema comicstor_private is private
SELECT has_schema('comicstor_private');
SELECT schema_privs_are('comicstor_private', 'comicstor_postgraphql', ARRAY [] :: TEXT []);
SELECT schema_privs_are('comicstor_private', 'comicstor_anonymous', ARRAY [] :: TEXT []);
SELECT schema_privs_are('comicstor_private', 'comicstor_user', ARRAY [] :: TEXT []);

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK;
