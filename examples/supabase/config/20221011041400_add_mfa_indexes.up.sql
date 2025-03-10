alter table auth.mfa_amr_claims
  add column if not exists id uuid not null;

do $$
begin
  if not exists
     (select constraint_name
      from information_schema.check_constraints
      where constraint_schema = 'auth'
      and constraint_name = 'amr_id_pk')
  then
    alter table auth.mfa_amr_claims add constraint amr_id_pk primary key(id);
  end if;
end $$;

create index if not exists user_id_created_at_idx on auth.sessions (user_id, created_at);
create index if not exists factor_id_created_at_idx on auth.mfa_factors (user_id, created_at);

