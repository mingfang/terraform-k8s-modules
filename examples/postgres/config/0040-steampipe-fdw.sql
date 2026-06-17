-- enable fdw extension
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- connect to target server
DROP SERVER IF EXISTS steampipe CASCADE;

CREATE SERVER IF NOT EXISTS steampipe
        FOREIGN DATA WRAPPER postgres_fdw
        OPTIONS (host 'steampipe.steampipe-example', port '9193', dbname 'steampipe', use_remote_estimate 'true');

CREATE USER MAPPING IF NOT EXISTS FOR postgres
        SERVER steampipe
        OPTIONS (user 'steampipe', password 'steampipe');

-- -- create local schema to `hold` foreign schema
CREATE SCHEMA IF NOT EXISTS jira;

-- -- import foreign schema
IMPORT FOREIGN SCHEMA jira FROM SERVER steampipe INTO jira;
