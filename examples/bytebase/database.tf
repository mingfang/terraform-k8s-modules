# Bytebase provider configuration
provider "bytebase" {
  url             = "http://bytebase.bytebase-example:8080"
  service_account = "admin@localhost"
  service_key     = "bbs_PC8ioNCBtXVthaufkEdN"
}

# Register the cloudnative-pg PostgreSQL instance in Bytebase
resource "bytebase_instance" "postgres" {
  title       = "cnpg-postgres"
  engine      = "POSTGRES"
  resource_id = "cnpg-postgres"

  data_sources {
    id       = "primary"
    type     = "ADMIN"
    host     = "cnpg-pooler.database.svc.cluster.local"
    port     = "5432"
    username = "postgres"
    password = "postgres12345"
    database = "postgres"
  }

  sync_databases = []
}

# Register the postgres database in Bytebase for migration tracking
resource "bytebase_database" "postgres" {
  name    = "instances/cnpg-postgres/databases/postgres"
  project = "projects/default"
}
