CREATE EXTENSION IF NOT EXISTS postgres_fdw;
ALTER EXTENSION postgres_fdw UPDATE;

DROP SERVER IF EXISTS keycloak CASCADE;

CREATE SERVER IF NOT EXISTS keycloak
        FOREIGN DATA WRAPPER postgres_fdw
        OPTIONS (host 'postgres.keycloak', port '5432', dbname 'keycloak', use_remote_estimate 'true');

CREATE USER MAPPING IF NOT EXISTS FOR postgres
        SERVER keycloak
        OPTIONS (user 'keycloak', password 'keycloak');

DROP SCHEMA IF EXISTS keycloak CASCADE;
CREATE SCHEMA IF NOT EXISTS keycloak;

IMPORT FOREIGN SCHEMA public FROM SERVER keycloak INTO keycloak;
