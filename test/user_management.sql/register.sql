BEGIN;

SET SEARCH_PATH TO public;

CREATE EXTENSION pgtap;

SELECT no_plan();

ALTER SEQUENCE comicstor.user_id_seq RESTART WITH 1;

SELECT is_empty(
  'select * from comicstor.user where name = ''jukkah''',
  'PRECONDITION: User jukkah doesn''t exist'
);

SELECT results_eq(
  'select comicstor.register(''jukkah'', ''jukkah@dev.null'', ''a good password is easy to remember but hard to brute force'')',
  ARRAY [(1, 'jukkah') :: comicstor.USER],
  'WHEN: User jukkah is registered'
);

SELECT isnt_empty(
  'select * from comicstor.user where name = ''jukkah''',
  'THEN: User jukkah exists'
);

SELECT throws_like(
  'select comicstor.register(''jukkah'', ''jukkah@dev.null'', ''a good password is easy to remember but hard to brute force'')',
  '%duplicate%',
  'AND: User jukkah can''t be registered twice'
);

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK;
