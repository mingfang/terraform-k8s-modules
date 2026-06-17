module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

# ── SeaweedFS for S3-compatible backup storage ──────────────────────────────

module "seaweedfs" {
  source           = "../seaweedfs"
  name             = "seaweedfs"
  namespace        = module.namespace.name
  create_namespace = false

  s3_access_key = var.seaweedfs_access_key
  s3_secret_key = var.seaweedfs_secret_key

  volume_storage_size  = "10Gi"
  volume_storage_class = "cephfs-csi"
}

# ── CloudNativePG Cluster (2-instance PostgreSQL with PgBouncer pooler) ──────
module "cluster" {
  source    = "../../modules/cloudnative-pg-cluster"
  name      = var.name
  namespace = module.namespace.name

  image_name = "registry.rebelsoft.com/cloudnative-documentdb:18.3-trixie"

  env_map = {
    "POSTGRES_PASSWORD" = var.postgres_password
  }

  instances    = 2
  storage_size = "10Gi"

  postgresql_shared_preload_libraries = [
    "pg_cron",
    "pg_documentdb_core",
    "pg_documentdb",
  ]

  postgresql_init_schemas = []

  postgresql_hba = [
    # Trust localhost connections for bg_worker and readwrite roles (must come before scram rules)
    "host all documentdb_bg_worker_role 127.0.0.1/32 trust",
    "host all documentdb_bg_worker_role ::1/128 trust",
    "host all documentdb_readwrite_role 127.0.0.1/32 trust",
    "host all documentdb_readwrite_role ::1/128 trust",
    "host all postgres 127.0.0.1/32 trust",
    "host all postgres ::1/128 trust",
  ]

  postgresql_parameters = {
    search_path           = "\\$user, public, documentdb"
    "cron.database_name"  = "postgres"
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
      "CREATE EXTENSION IF NOT EXISTS documentdb_core CASCADE;",
      "CREATE EXTENSION IF NOT EXISTS documentdb CASCADE;",
      "SET documentdb.enable_create_collection_on_insert = on;",
      "DO $$ BEGIN CREATE ROLE documentdb_bg_worker_role; EXCEPTION WHEN duplicate_object THEN NULL; END $$;",
      "DO $$ BEGIN CREATE ROLE documentdb_readwrite_role; EXCEPTION WHEN duplicate_object THEN NULL; END $$;",
      "ALTER ROLE documentdb_bg_worker_role WITH PASSWORD '${var.postgres_password}';",
      "ALTER ROLE documentdb_readwrite_role WITH PASSWORD '${var.postgres_password}';",
      "DO $$ DECLARE r record; BEGIN FOR r IN (SELECT nspname FROM pg_namespace WHERE nspname LIKE 'documentdb%') LOOP EXECUTE format('GRANT ALL ON SCHEMA %I TO streaming_replica', r.nspname); END LOOP; END $$;",
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
    enabled          = true
    destination_path = "s3://cloudnative-pg-backups/cloudnative-pg/"
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

# ── Grant pooler role access to all documentdb schemas (required for auth_query) ──
resource "k8s_batch_v1_job" "grant_documentdb_pooler_access" {
  metadata {
    name      = "${var.name}-grant-pooler-access"
    namespace = module.namespace.name
  }

  spec {
    backoff_limit = 1
    ttl_seconds_after_finished = 3600
    template {
      spec {
        restart_policy = "Never"
        containers {
          name  = "grant-access"
          image = "registry.rebelsoft.com/cloudnative-documentdb:18.3-trixie"
          command = ["/bin/bash", "-c"]
          args = [
            "PGPASSWORD=\"$POSTGRES_PASSWORD\" psql -h ${var.name}-rw -U postgres -d postgres -c \"DO \\$\\$ DECLARE r record; BEGIN FOR r IN (SELECT nspname FROM pg_namespace WHERE nspname LIKE 'documentdb%') LOOP EXECUTE format('GRANT ALL ON SCHEMA %I TO cnpg_pooler_pgbouncer', r.nspname); END LOOP; END \\$\\$;\""
          ]
          env {
            name  = "POSTGRES_PASSWORD"
            value = var.postgres_password
          }
        }
      }
    }
  }

  depends_on = [
    module.cluster.cluster_service_name
  ]
}
