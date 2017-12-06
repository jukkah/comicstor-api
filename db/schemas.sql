-- depends_on: roles.sql

-- Schema for private part of comicstor
CREATE SCHEMA IF NOT EXISTS comicstor_private;

-- Schema for public part of comicstor
CREATE SCHEMA IF NOT EXISTS comicstor;

GRANT USAGE ON SCHEMA comicstor TO comicstor_anonymous, comicstor_user;
