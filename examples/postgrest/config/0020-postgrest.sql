-- Set up PostgREST
create user authenticator noinherit;

create role anon nologin noinherit;
grant anon to authenticator;

create user authenticated nologin noinherit;
grant authenticated to authenticator;

grant usage on schema public to postgres, authenticated;
grant usage on schema extensions to postgres, authenticated;

grant all on all tables in schema public to postgres, authenticated;
alter default privileges in schema public grant all on tables to postgres, authenticated;

grant all on all functions in schema public to postgres, authenticated;
alter default privileges in schema public grant all on functions to postgres, authenticated;

grant all on all sequences in schema public to postgres, authenticated;
alter default privileges in schema public grant all on sequences to postgres, authenticated;


-- https://postgrest.org/en/latest/schema_cache.html#finer-grained-event-trigger
-- watch create and alter
CREATE OR REPLACE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger AS $$
DECLARE
    cmd record;
BEGIN
    FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
        LOOP
            IF cmd.command_tag IN (
                'CREATE SCHEMA', 'ALTER SCHEMA'
                , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
                , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
                , 'CREATE VIEW', 'ALTER VIEW'
                , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
                , 'CREATE FUNCTION', 'ALTER FUNCTION'
                , 'CREATE TRIGGER'
                , 'CREATE TYPE', 'ALTER TYPE'
                , 'CREATE RULE'
                , 'COMMENT'
                )
                -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
                AND cmd.schema_name is distinct from 'pg_temp'
            THEN
                NOTIFY pgrst, 'reload schema';
            END IF;
        END LOOP;
END; $$ LANGUAGE plpgsql;

-- watch drop
CREATE OR REPLACE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger AS $$
DECLARE
    obj record;
BEGIN
    FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
        LOOP
            IF obj.object_type IN (
                                   'schema'
                , 'table'
                , 'foreign table'
                , 'view'
                , 'materialized view'
                , 'function'
                , 'trigger'
                , 'type'
                , 'rule'
                )
                AND obj.is_temporary IS false -- no pg_temp objects
            THEN
                NOTIFY pgrst, 'reload schema';
            END IF;
        END LOOP;
END; $$ LANGUAGE plpgsql;

DROP EVENT TRIGGER IF EXISTS pgrst_ddl_watch;
CREATE EVENT TRIGGER pgrst_ddl_watch
    ON ddl_command_end
  EXECUTE PROCEDURE extensions.pgrst_ddl_watch();

DROP EVENT TRIGGER IF EXISTS pgrst_drop_watch;
CREATE EVENT TRIGGER pgrst_drop_watch
    ON sql_drop
  EXECUTE PROCEDURE extensions.pgrst_drop_watch();

-- Set password
\set pgpass `echo "$POSTGRES_PASSWORD"`
alter user authenticator with password :'pgpass';