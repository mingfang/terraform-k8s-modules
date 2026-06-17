select * from audit.record_version;

id |              record_id               |            old_record_id             |    op    |              ts               | table_oid | table_schema | table_name |                 record                 |               old_record               
----+--------------------------------------+--------------------------------------+----------+-------------------------------+-----------+--------------+------------+----------------------------------------+----------------------------------------
  1 | b097042f-7f48-515c-857b-74e962b4d316 |                                      | INSERT   | 2024-03-31 23:48:21.162482+00 |    589222 | public       | account    | {"id": 1, "name": "Foo Barsworth"}     | 
  2 | b097042f-7f48-515c-857b-74e962b4d316 | b097042f-7f48-515c-857b-74e962b4d316 | UPDATE   | 2024-04-01 00:28:43.025678+00 |    589222 | public       | account    | {"id": 1, "name": "Foo Barsworht III"} | {"id": 1, "name": "Foo Barsworth"}
  3 | 1bd24713-29c0-5522-835a-4bb7d4fc18c7 |                                      | INSERT   | 2024-04-01 00:34:36.022338+00 |    589222 | public       | account    | {"id": 2, "name": "two bar"}           | 
  4 |                                      | b097042f-7f48-515c-857b-74e962b4d316 | DELETE   | 2024-04-01 00:34:47.309835+00 |    589222 | public       | account    |                                        | {"id": 1, "name": "Foo Barsworht III"}
  5 |                                      |                                      | TRUNCATE | 2024-04-01 00:44:55.551169+00 |    589222 | public       | account    |                                        | 

select record from audit.record_version where table_oid = 'public.account'::regclass::oid and (record->'id')::int = 1;
select pg_typeof(record->'id') from audit.record_version limit 1;

explain
with 
a as (
    select * from audit.record_version where id=1
),
b as (
    select b.* from a, audit.record_version b where a.table_oid=b.table_oid  and a.record->'id'=b.record->'id'
    order by b.id desc limit 1
)
select a.record, b.record,a.record->>'name' <> b.record->>'name' as match from a, b;
