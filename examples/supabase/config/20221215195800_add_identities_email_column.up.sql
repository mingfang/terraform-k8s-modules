update
  auth.identities as identities
set
  identity_data = identity_data || jsonb_build_object('email', (select email from auth.users where id = identities.user_id)),
  updated_at = '2022-11-25'
where identities.provider = 'email' and identity_data->>'email' is null;

alter table only auth.identities
  add column if not exists email text generated always as (lower(identity_data->>'email')) stored;

comment on column auth.identities.email is 'Auth: Email is a generated column that references the optional email property in the identity_data';

create index if not exists identities_email_idx on auth.identities (email text_pattern_ops);

comment on index auth.identities_email_idx is 'Auth: Ensures indexed queries on the email column';
