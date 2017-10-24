BEGIN;

SET SEARCH_PATH TO public;

CREATE EXTENSION pgtap;

SELECT no_plan();

SELECT results_eq(
  'select _v.is_executed(''test/versions.sql/set_executed_1.sql'', ''v1'')',
  ARRAY [FALSE],
  'PRECONDITION: File test/versions.sql/set_executed_1.sql with version v1 should not be executed'
);

SELECT results_eq(
  'select _v.is_executed(''test/versions.sql/set_executed_1.sql'', ''v2'')',
  ARRAY [FALSE],
  'PRECONDITION: File test/versions.sql/set_executed_1.sql with version v2 should not be executed'
);

---

SELECT lives_ok(
  'select _v.set_executed(''test/versions.sql/set_executed_1.sql'', ''v1'')',
  'WHEN: File test/versions.sql/set_executed_1.sql is executed with version v1'
);

---

SELECT results_eq(
  'select _v.is_executed(''test/versions.sql/set_executed_1.sql'', ''v1'')',
  ARRAY [TRUE],
  'THEN: File test/versions.sql/set_executed_1.sql with version v1 should be executed'
);


SELECT results_eq(
  'select _v.is_executed(''test/versions.sql/set_executed_1.sql'', ''v2'')',
  ARRAY [FALSE],
  'AND: File test/versions.sql/set_executed_1.sql with version v2 should not be executed'
);

SELECT lives_ok(
  'select _v.set_executed(''test/versions.sql/set_executed_1.sql'', ''v1'')',
  'AND: File test/versions.sql/set_executed_1.sql can be executed again with already executed version v1'
);

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK;
