CREATE ROLE postgres WITH
    LOGIN
    SUPERUSER
    INHERIT
    CREATEDB
    CREATEROLE
    REPLICATION
    ENCRYPTED PASSWORD 'md53175bce1d3201d16594cebf9d7eb3f9d';

GRANT pg_read_all_data, pg_write_all_data TO postgres;

ALTER ROLE postgres SET search_path TO "\$user", public, extensions;

create extension if not exists plpgsql;