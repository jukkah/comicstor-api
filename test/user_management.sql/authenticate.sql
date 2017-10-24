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
  'select comicstor.authenticate(''jukkah@dev.null'', ''a good password is easy to remember but hard to brute force'')',
  ARRAY [('comicstor_user', 1) :: comicstor.JWT_TOKEN],
  'Authentication success with correct email and password'
);

SELECT results_eq(
  'select comicstor.authenticate(''no-one@dev.null'', ''a good password is easy to remember but hard to brute force'')',
  ARRAY [NULL :: comicstor.JWT_TOKEN],
  'Authentication fails with incorrect email'
);

SELECT results_eq(
  'select comicstor.authenticate(''jukkah@dev.null'', ''incorrect password'')',
  ARRAY [NULL :: comicstor.JWT_TOKEN],
  'Authentication fails with incorrect password'
);

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK;
