BEGIN;

SET SEARCH_PATH TO public;

CREATE EXTENSION pgtap;

SELECT no_plan();

ALTER SEQUENCE comicstor.user_id_seq RESTART WITH 1;

SELECT lives_ok(
  'select comicstor.register(''jukkah'', ''jukkah@dev.null'', ''a good password is easy to remember but hard to brute force'')',
  'SETUP: Register user jukkah'
);

SELECT results_eq(
  'select comicstor.current_user_id()',
  ARRAY [NULL :: INTEGER],
  'Current user ID is null for anonymous user'
);

SELECT results_eq(
  'select comicstor.current_user()',
  ARRAY [NULL :: comicstor.user],
  'Current user is null for anonymous user'
);

SET LOCAL jwt.claims.user_id TO 1;

SELECT results_eq(
  'select comicstor.current_user_id()',
  ARRAY [1],
  'Current user ID is 1 when authenticated as jukkah'
);

SELECT results_eq(
  'select comicstor.current_user()',
  ARRAY [(1, 'jukkah') :: comicstor.user],
  'Current user is jukkah when authenticated as jukkah'
);

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK;
