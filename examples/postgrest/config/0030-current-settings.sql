DROP FUNCTION IF EXISTS public.current_setting(text);

create or replace function public.current_setting(name text) returns text as $$
select nullif(current_setting(name, true), '')::text;
$$ language sql stable;
