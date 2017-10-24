BEGIN;

SET SEARCH_PATH TO public;

CREATE EXTENSION pgtap;

SELECT no_plan();

SELECT results_eq(
  'select _v.is_executed(''test/versions.sql/set_executed_2.sql'', ''v1'')',
  ARRAY [FALSE],
  'PRECONDITION: File test/versions.sql/set_executed_2.sql with version v1 should not be executed'
);

SELECT results_eq(
  'select _v.is_executed(''test/versions.sql/set_executed_2.sql'', ''v2'')',
  ARRAY [FALSE],
  'PRECONDITION: File test/versions.sql/set_executed_2.sql with version v2 should not be executed'
);

SELECT results_eq(
  'select _v.is_executed(''test/versions.sql/set_executed_2.sql'', ''v3'')',
  ARRAY [FALSE],
  'PRECONDITION: File test/versions.sql/set_executed_2.sql with version v3 should not be executed'
);

---

SELECT lives_ok(
  'select _v.set_executed(''test/versions.sql/set_executed_2.sql'', array[''v1'', ''v2''])',
  'WHEN: File test/versions.sql/set_executed_2.sql is executed with versions v1 and v2'
);

---

SELECT results_eq(
  'select _v.is_executed(''test/versions.sql/set_executed_2.sql'', ''v1'')',
  ARRAY [TRUE],
  'THEN: File test/versions.sql/set_executed_2.sql with version v1 should be executed'
);

SELECT results_eq(
  'select _v.is_executed(''test/versions.sql/set_executed_2.sql'', ''v2'')',
  ARRAY [TRUE],
  'AND: File test/versions.sql/set_executed_2.sql with version v2 should be executed'
);

SELECT results_eq(
  'select _v.is_executed(''test/versions.sql/set_executed_2.sql'', ''v3'')',
  ARRAY [FALSE],
  'AND: File test/versions.sql/set_executed_2.sql with version v3 should not be executed'
);

SELECT lives_ok(
  'select _v.set_executed(''test/versions.sql/set_executed_2.sql'', array[''v1'', ''v2''])',
  'AND: File test/versions.sql/set_executed_2.sql can be executed again with already executed versions v1 and v2'
);

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK;
