DROP FUNCTION IF EXISTS current_setting(text);

create or replace function current_setting(name text) returns json as $$
select nullif(current_setting(name, true), '')::json;
$$ language sql stable;
