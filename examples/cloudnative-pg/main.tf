module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

# ── SeaweedFS for S3-compatible backup storage ──────────────────────────────

module "seaweedfs" {
  source    = "../seaweedfs"
  name      = var.name
  namespace = module.namespace.name
  create_namespace = false

  s3_access_key     = var.seaweedfs_access_key
  s3_secret_key     = var.seaweedfs_secret_key

  volume_storage_size = "10Gi"
  volume_storage_class = "cephfs-csi"
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
    endpoint_url               = module.seaweedfs.endpoint_url
    s3_credentials_secret_name = module.seaweedfs.credentials_secret_name
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
