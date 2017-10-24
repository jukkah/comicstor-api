BEGIN;

SET SEARCH_PATH TO public, _v;

CREATE EXTENSION pgtap;

SELECT no_plan();

-- basic structure of schema _v
SELECT has_schema('_v');
SELECT tables_are('_v', ARRAY ['version']);
SELECT functions_are('_v', ARRAY ['set_executed', 'is_executed']);

-- basic structure of table _v.version
SELECT columns_are('_v', 'version', ARRAY ['file', 'version', 'executed_at']);
SELECT col_type_is('version', 'file', 'character varying(50)');
SELECT col_type_is('version', 'version', 'character varying(50)');
SELECT col_type_is('version', 'executed_at', 'timestamp without time zone');
SELECT col_is_pk('version', ARRAY ['file', 'version']);
SELECT col_default_is('version', 'executed_at', 'now()');

-- function _v.set_executed(text, text): void
SELECT has_function('_v', 'set_executed', ARRAY ['text', 'text']);
SELECT function_returns('_v', 'set_executed', ARRAY ['text', 'text'], 'void');
SELECT isnt_definer('_v', 'set_executed', ARRAY ['text', 'text']);
SELECT isnt_strict('_v', 'set_executed', ARRAY ['text', 'text']);
SELECT volatility_is('_v', 'set_executed', ARRAY ['text', 'text'], 'volatile');

SELECT function_privs_are('_v', 'set_executed', ARRAY ['text', 'text'], 'comicstor_anonymous', '{}');
SELECT function_privs_are('_v', 'set_executed', ARRAY ['text', 'text'], 'comicstor_user', '{}');

-- function _v.set_executed(text, text[]): void
SELECT has_function('_v', 'set_executed', ARRAY ['text', 'text[]']);
SELECT function_returns('_v', 'set_executed', ARRAY ['text', 'text[]'], 'void');
SELECT isnt_definer('_v', 'set_executed', ARRAY ['text', 'text[]']);
SELECT isnt_strict('_v', 'set_executed', ARRAY ['text', 'text[]']);
SELECT volatility_is('_v', 'set_executed', ARRAY ['text', 'text[]'], 'volatile');

SELECT function_privs_are('_v', 'set_executed', ARRAY ['text', 'text[]'], 'comicstor_anonymous', '{}');
SELECT function_privs_are('_v', 'set_executed', ARRAY ['text', 'text[]'], 'comicstor_user', '{}');

-- function _v.is_executed(text, text): boolean
SELECT has_function('_v', 'is_executed', ARRAY ['text', 'text']);
SELECT function_returns('_v', 'is_executed', ARRAY ['text', 'text'], 'boolean');
SELECT isnt_definer('_v', 'is_executed', ARRAY ['text', 'text']);
SELECT isnt_strict('_v', 'is_executed', ARRAY ['text', 'text']);
SELECT volatility_is('_v', 'is_executed', ARRAY ['text', 'text'], 'stable');

SELECT function_privs_are('_v', 'is_executed', ARRAY ['text', 'text'], 'comicstor_anonymous', '{}');
SELECT function_privs_are('_v', 'is_executed', ARRAY ['text', 'text'], 'comicstor_user', '{}');

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK;
