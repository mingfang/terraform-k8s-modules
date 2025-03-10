CREATE ROLE postgres WITH
    LOGIN
    SUPERUSER
    INHERIT
    CREATEDB
    CREATEROLE
    REPLICATION
    ENCRYPTED PASSWORD 'SCRAM-SHA-256$4096:nrBvXqgv+3WMm3LnR+aGMg==$aOsPfs6J0ocngheT4Fvz0Qh3NUwYAZHTeqpDXasFdWw=:0Tj76yLs2JiOHUj5seNnJjNFUJP/ynBMJKkTADLbquw=';

GRANT pg_read_all_data, pg_write_all_data TO postgres;
