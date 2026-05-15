module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

# ── SeaweedFS for S3-compatible backup storage ──────────────────────────────
# Simple 3-tier SeaweedFS (master + volume + filer + S3 gateway)

locals {
  seaweedfs_access_key = "seaweedfs"
  seaweedfs_secret_key = "seaweedfs123"
}

# SeaweedFS master — uses default entrypoint.sh, passes "master" as subcommand
module "seaweedfs-master" {
  source    = "../../modules/generic-deployment-service"
  name      = "seaweedfs-master"
  namespace = module.namespace.name

  image = "chrislusf/seaweedfs:latest"

  ports_map = {
    grpc = 9333
  }

  args = ["master", "-ip.bind=0.0.0.0"]

  resources = {
    requests = { cpu = "100m", memory = "100Mi" }
    limits   = { memory = "200Mi" }
  }
}

# SeaweedFS volume — uses default entrypoint.sh, passes "volume" as subcommand
module "seaweedfs-volume" {
  source    = "../../modules/generic-deployment-service"
  name      = "seaweedfs-volume"
  namespace = module.namespace.name

  image = "chrislusf/seaweedfs:latest"

  ports_map = {
    http = 8080
  }

  args = ["volume", "-ip.bind=0.0.0.0", "-port=8080", "-master=seaweedfs-master:9333"]

  resources = {
    requests = { cpu = "100m", memory = "500Mi" }
    limits   = { memory = "1Gi" }
  }
}

# SeaweedFS filer
module "seaweedfs-filer" {
  source    = "../../modules/generic-deployment-service"
  name      = "seaweedfs-filer"
  namespace = module.namespace.name

  image = "chrislusf/seaweedfs:latest"

  ports_map = {
    http = 8888
  }

  args = ["filer", "-master=seaweedfs-master:9333", "-ip.bind=0.0.0.0"]

  resources = {
    requests = { cpu = "100m", memory = "200Mi" }
    limits   = { memory = "500Mi" }
  }
}

# SeaweedFS S3 gateway
module "seaweedfs-s3" {
  source    = "../../modules/generic-deployment-service"
  name      = "seaweedfs-s3"
  namespace = module.namespace.name

  image = "chrislusf/seaweedfs:latest"

  ports_map = {
    s3 = 8333
  }

  args = ["s3", "-filer=seaweedfs-filer:8888", "-ip.bind=0.0.0.0"]

  resources = {
    requests = { cpu = "100m", memory = "200Mi" }
    limits   = { memory = "500Mi" }
  }
}

# Credentials secret for Barman Cloud Plugin (S3-compatible object store auth)
resource "k8s_core_v1_secret" "s3_credentials" {
  metadata {
    name      = "cloudnative-pg-s3-credentials"
    namespace = module.namespace.name
  }

  data = {
    ACCESS_KEY_ID     = base64encode(local.seaweedfs_access_key)
    ACCESS_SECRET_KEY = base64encode(local.seaweedfs_secret_key)
  }

  type = "Opaque"
}

# ── CloudNativePG Cluster (2-instance PostgreSQL with PgBouncer pooler) ──────
module "cluster" {
  source    = "../../modules/cloudnative-pg-cluster"
  name      = var.name
  namespace = module.namespace.name

  image_name = "registry.rebelsoft.com/cloudnative-vchord-suite:18.3-trixie"

  env_map = {
    "POSTGRES_PASSWORD" = var.postgres_password
  }

  instances    = 2
  storage_size = "10Gi"

  postgresql_shared_preload_libraries = ["vchord", "vchord_bm25", "vector", "pg_tokenizer"]

  postgresql_init_schemas = ["bm25_catalog", "tokenizer_catalog"]

  postgresql_parameters = {
    max_wal_senders = "10"
    search_path     = "\\$user, public, bm25_catalog, tokenizer_catalog"
  }

  pooler = {
    name            = "${var.name}-pooler"
    max_client_conn = 100
    pool_mode       = "transaction"
    instances       = 1
    pg_hba          = []
  }

  bootstrap = {
    database = "postgres"
    owner    = var.postgres_user
    post_init_application_sql = [
      "CREATE EXTENSION IF NOT EXISTS vchord CASCADE;",
      "CREATE EXTENSION IF NOT EXISTS pg_tokenizer CASCADE;",
      "CREATE EXTENSION IF NOT EXISTS vchord_bm25 CASCADE;",
    ]
  }

  resources = {
    requests = {
      cpu    = "2"
      memory = "4Gi"
    }
    limits = {
      memory = "8Gi"
    }
  }

  # ── Barman Cloud Plugin: WAL archiving & backups to SeaweedFS S3 ──
  barman_cloud = {
    enabled                    = true
    destination_path           = "s3://cloudnative-pg-backups/cloudnative-pg/"
    endpoint_url               = "http://seaweedfs-s3:8333"
    s3_credentials_secret_name = "cloudnative-pg-s3-credentials"
    wal_compression            = "gzip"
    data_compression           = "gzip"
    retention_policy           = "30d"
  }

  scheduled_backup = {
    enabled                = true
    schedule               = "0 0 0 * * *"
    backup_owner_reference = "cluster"
  }
}
