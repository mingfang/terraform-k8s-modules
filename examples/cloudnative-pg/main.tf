module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

# ── SeaweedFS for S3-compatible backup storage ──────────────────────────────

module "seaweedfs" {
  source    = "../seaweedfs"
  name      = "seaweedfs"
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
    search_path           = "\\$user, public, bm25_catalog, tokenizer_catalog"
    max_replication_slots = "32"
    wal_keep_size         = "512MB"
    wal_level             = "logical"
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
    enabled            = true
    destination_path   = "s3://cloudnative-pg-backups/cloudnative-pg/"
    name             = "${var.name}-backup"
    endpoint_url       = module.seaweedfs.endpoint_url
    s3_credentials = {
      access_key_id_name     = module.seaweedfs.credentials_secret_name
      access_key_id_key      = "ACCESS_KEY_ID"
      secret_access_key_name = module.seaweedfs.credentials_secret_name
      secret_access_key_key  = "ACCESS_SECRET_KEY"
      region = {
        secret_name = ""
        secret_key  = "REGION"
      }
    }
    inherit_from_iam_role = false
    wal = {
      compression  = "gzip"
      max_parallel = 0
      encryption   = ""
    }
    data = {
      compression          = "gzip"
      encryption           = ""
      jobs                 = 0
      immediate_checkpoint = false
    }
    retention_policy = "30d"
  }

  scheduled_backup = {
    enabled                = true
    schedule               = "0 0 0 * * *"
    backup_owner_reference = "cluster"
  }
}
