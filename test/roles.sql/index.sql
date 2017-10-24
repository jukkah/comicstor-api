BEGIN;

SET SEARCH_PATH TO public;

CREATE EXTENSION pgtap;

SELECT no_plan();

SELECT has_role('comicstor_postgraphql');
SELECT has_role('comicstor_anonymous');
SELECT has_role('comicstor_user');

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK;
