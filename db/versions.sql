-- Schema for version management
CREATE SCHEMA IF NOT EXISTS _v;

ALTER DEFAULT PRIVILEGES REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;

--------------------------------------------------------------------------------

-- Table for persisted version history
CREATE TABLE IF NOT EXISTS _v.version (
  -- filename/path as context
  file CHARACTER VARYING(50) NOT NULL,
  -- the version name
  version CHARACTER VARYING(50) NOT NULL,
  -- timestamp of execution
  executed_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),

  PRIMARY KEY (file, version)
);

--------------------------------------------------------------------------------

-- Set version as executed in file
DROP FUNCTION IF EXISTS _v.set_executed( TEXT, TEXT );
CREATE FUNCTION _v.set_executed(file TEXT, version TEXT) RETURNS VOID AS $$
  INSERT INTO _v.version (file, version)
  VALUES (set_executed.file, set_executed.version)
  ON CONFLICT (file, version)
  DO UPDATE SET executed_at = now()
$$ LANGUAGE SQL VOLATILE;

--------------------------------------------------------------------------------

-- Set multiple versions as executed in file
DROP FUNCTION IF EXISTS _v.set_executed( TEXT, TEXT [] );
CREATE FUNCTION _v.set_executed(file TEXT, versions TEXT []) RETURNS VOID AS $$
  INSERT INTO _v.version (file, version)
  SELECT set_executed.file AS file, version
  FROM UNNEST(set_executed.versions) version
  ON CONFLICT (file, version)
  DO UPDATE SET executed_at = now()
$$ LANGUAGE SQL VOLATILE;

--------------------------------------------------------------------------------

-- Check if version is already executed in file
DROP FUNCTION IF EXISTS _v.is_executed( TEXT, TEXT );
CREATE FUNCTION _v.is_executed(file TEXT, version TEXT) RETURNS BOOLEAN AS $$
  SELECT EXISTS(
    SELECT 1
    FROM _v.version
    WHERE file = is_executed.file AND version = is_executed.version
  )
$$ LANGUAGE SQL STABLE;
