BEGIN;

SET SEARCH_PATH TO public, comicstor, comicstor_private;

CREATE EXTENSION pgtap;

SELECT no_plan();

-- basic structure of table comicstor.user
SELECT has_table('comicstor' :: NAME, 'user' :: NAME);
SELECT columns_are('comicstor', 'user', ARRAY ['id', 'name']);
SELECT col_type_is('user', 'id', 'integer');
SELECT col_type_is('user', 'name', 'character varying(20)');
SELECT col_is_pk('user', 'id');
SELECT col_not_null('user', 'name');

SELECT table_privs_are('comicstor', 'user', 'comicstor_anonymous', ARRAY ['SELECT']);
SELECT table_privs_are('comicstor', 'user', 'comicstor_user', ARRAY ['SELECT', 'UPDATE', 'DELETE']);

-- basic structure of table comicstor_private.user_account
SELECT has_table('comicstor_private' :: NAME, 'user_account' :: NAME);
SELECT columns_are('comicstor_private', 'user_account', ARRAY ['user_id', 'email', 'password_hash']);
SELECT col_type_is('user_account', 'user_id', 'integer');
SELECT col_type_is('user_account', 'email', 'character varying(254)');
SELECT col_type_is('user_account', 'password_hash', 'character(60)');
SELECT col_is_fk('user_account', 'user_id');
SELECT fk_ok('user_account', 'user_id', 'user', 'id');
SELECT col_not_null('user_account', 'email');
SELECT col_is_unique('user_account', 'email');
SELECT col_not_null('user_account', 'password_hash');

SELECT table_privs_are('comicstor_private', 'user_account', 'comicstor_anonymous', ARRAY [] :: TEXT []);
SELECT table_privs_are('comicstor_private', 'user_account', 'comicstor_user', ARRAY [] :: TEXT []);

-- basic structure of type comicstor.jwt_token
SELECT has_type('comicstor' :: NAME, 'jwt_token' :: NAME);

-- function comicstor.register(text, text, text): comicstor.user
SELECT has_function('comicstor', 'register', ARRAY ['text', 'text', 'text']);
SELECT function_returns('comicstor', 'register', ARRAY ['text', 'text', 'text'], '"user"');
SELECT is_definer('comicstor', 'register', ARRAY ['text', 'text', 'text']);
SELECT is_strict('comicstor', 'register', ARRAY ['text', 'text', 'text']);
SELECT volatility_is('comicstor', 'register', ARRAY ['text', 'text', 'text'], 'volatile');

SELECT function_privs_are('comicstor', 'register', ARRAY ['text', 'text', 'text'], 'comicstor_anonymous', ARRAY ['EXECUTE']);
SELECT function_privs_are('comicstor', 'register', ARRAY ['text', 'text', 'text'], 'comicstor_user', '{}');

-- function comicstor.authenticate(text, text): comicstor.jwt_token
SELECT has_function('comicstor', 'authenticate', ARRAY ['text', 'text']);
SELECT function_returns('comicstor', 'authenticate', ARRAY ['text', 'text'], 'jwt_token');
SELECT is_definer('comicstor', 'authenticate', ARRAY ['text', 'text']);
SELECT is_strict('comicstor', 'authenticate', ARRAY ['text', 'text']);
SELECT volatility_is('comicstor', 'authenticate', ARRAY ['text', 'text'], 'stable');

SELECT function_privs_are('comicstor', 'authenticate', ARRAY ['text', 'text'], 'comicstor_anonymous', ARRAY ['EXECUTE']);
SELECT function_privs_are('comicstor', 'authenticate', ARRAY ['text', 'text'], 'comicstor_user', ARRAY ['EXECUTE']);

-- function comicstor.current_user(): comicstor.user
SELECT has_function('comicstor', 'current_user', ARRAY [] :: TEXT []);
SELECT function_returns('comicstor', 'current_user', ARRAY [] :: TEXT [], '"user"');
SELECT isnt_definer('comicstor', 'current_user', ARRAY [] :: TEXT []);
SELECT isnt_strict('comicstor', 'current_user', ARRAY [] :: TEXT []);
SELECT volatility_is('comicstor', 'current_user', ARRAY [] :: TEXT [], 'stable');

SELECT function_privs_are('comicstor', 'current_user', ARRAY [] :: TEXT [], 'comicstor_anonymous', ARRAY ['EXECUTE']);
SELECT function_privs_are('comicstor', 'current_user', ARRAY [] :: TEXT [], 'comicstor_user', ARRAY ['EXECUTE']);

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK;
