drop source if exists pg_mydb;
CREATE SOURCE pg_mydb 
-- INCLUDE timestamp AS ts
WITH (
    connector = 'postgres-cdc', 
    hostname = 'postgres.postgres-example', 
    port = '5432', 
    username = 'postgres', 
    password = 'postgres', 
    database.name = 'postgres', 
    slot.name = 'mydb_slot'
) 
FORMAT PLAIN ENCODE JSON;

DROP TABLE IF EXISTS course; 
CREATE TABLE courses (id INTEGER, title TEXT, PRIMARY KEY (id)) 
-- INCLUDE timestamp AS ts
FROM pg_mydb TABLE 'public.courses';

DROP TABLE IF EXISTS course; 
CREATE TABLE courses (*, PRIMARY KEY (id)) 
-- INCLUDE timestamp AS ts
FROM pg_mydb TABLE 'public.courses';

-- CREATE MATERIALIZED VIEW courses_mv AS
-- SELECT * 
-- FROM pg_mydb TABLE 'public.courses';

-- drop table if exists courses;
-- create table courses (id integer, title text, primary key (id)) 
-- include timestamp as ts
-- WITH (
--     connector = 'postgres-cdc', 
--     hostname = 'postgres.postgres-example', 
--     port = '5432', 
--     username = 'postgres', 
--     password = 'postgres', 
--     database.name = 'postgres', 
--     schema.name = 'public',
--     table.name = 'courses',
--     slot.name = 'mydb_slot'
-- );