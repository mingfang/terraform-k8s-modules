rm *.conf || true

shopt -s nullglob
for sql in {00,20}*.sql; do
  echo "$0: Removing $sql";
  rm $sql
done

# https://github.com/supabase/postgres/tree/develop/migrations

#wget --backups=1 https://raw.githubusercontent.com/supabase/postgres/develop/ansible/files/postgresql_config/postgresql.conf.j2 -O postgresql.conf
#wget --backups=1 https://raw.githubusercontent.com/supabase/postgres/develop/ansible/files/postgresql_config/pg_ident.conf.j2 -O pg_ident.conf
#wget --backups=1 https://raw.githubusercontent.com/supabase/postgres/develop/ansible/files/postgresql_config/pg_hba.conf.j2 -O pg_hba.conf

wget --backups=1 https://raw.githubusercontent.com/supabase/postgres/develop/migrations/db/migrate.sh -O migrate.sh
svn export --force https://github.com/supabase/postgres/branches/develop/migrations/db/init-scripts .
svn export --force https://github.com/supabase/postgres/branches/develop/migrations/db/migrations .

# skip safeupdate; not installed
rm *_enable-safeupdate-postgrest.sql

# https://github.com/supabase/gotrue/tree/master/migrations
svn export --force https://github.com/supabase/gotrue/branches/master/migrations .
sed -i -e 's|{{ index .Options "Namespace" }}|auth|' *.sql