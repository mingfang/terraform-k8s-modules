CREATE EXTENSION IF NOT EXISTS mysql_fdw;
ALTER EXTENSION mysql_fdw UPDATE;

DROP SERVER IF EXISTS matomo CASCADE;
CREATE SERVER IF NOT EXISTS matomo
	FOREIGN DATA WRAPPER mysql_fdw
	OPTIONS (host 'mysql.matomo-example', port '3306', use_remote_estimate 'true');

CREATE USER MAPPING IF NOT EXISTS FOR postgres
	SERVER matomo
	OPTIONS (username 'matomo', password 'matomo');

DROP SCHEMA IF EXISTS matomo CASCADE;
CREATE SCHEMA IF NOT EXISTS matomo;
IMPORT FOREIGN SCHEMA matomo FROM SERVER matomo INTO matomo
	OPTIONS (import_default 'false', import_not_null 'false', import_enum_as_text 'true');
