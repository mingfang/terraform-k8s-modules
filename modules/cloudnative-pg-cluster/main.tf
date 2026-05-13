locals {
  password_secret_name = var.password_secret_name != null ? var.password_secret_name : "${var.name}-password"
  owner_password_secret_name = "${var.name}-owner-password"

  # Build pooler config with defaults merged in
  pooler_config = merge({
    name            = null
    max_client_conn = 100
    pool_mode       = "transaction"
    instances       = 1
    pg_hba          = []
  }, var.pooler)

  pooler_enabled = local.pooler_config.name != null
  pooler_name    = local.pooler_enabled ? local.pooler_config.name : null

  monitoring_queries_config_map_name = var.monitoring != null && length(var.monitoring_custom_queries) > 0 ? "${var.name}-monitoring-queries" : null

  # pg_hba defaults
  default_pg_hba = [
    "host all all 0.0.0.0/0 scram-sha-256",
    "host all all ::/0 scram-sha-256",
  ]

  # postgresql_hba default: use var value if provided, otherwise module default
  effective_pg_hba = length(var.postgresql_hba) > 0 ? var.postgresql_hba : local.default_pg_hba

  # pooler pg_hba: use user-provided or fall back to default
  pooler_pg_hba = local.pooler_config.pg_hba
  effective_pooler_pg_hba = length(local.pooler_pg_hba) > 0 ? local.pooler_pg_hba : local.default_pg_hba

  affinity_config = {
    enable_pod_anti_affinity = var.affinity.enable_pod_anti_affinity
    pod_anti_affinity_type   = var.affinity.pod_anti_affinity_type
    topology_key             = var.affinity.topology_key
    node_selector            = var.affinity.node_selector
  }

  pg_password = lookup(var.env_map, "POSTGRES_PASSWORD", "postgres")

  # Build GRANT SQL for init schemas — grants USAGE, CREATE, ALL TABLES/SEQUENCES, and default privileges
  init_schemas_grants = flatten([
    for schema in var.postgresql_init_schemas : [
      "GRANT USAGE ON SCHEMA ${schema} TO ${var.bootstrap.owner};",
      "GRANT CREATE ON SCHEMA ${schema} TO ${var.bootstrap.owner};",
      "GRANT ALL ON ALL TABLES IN SCHEMA ${schema} TO ${var.bootstrap.owner};",
      "GRANT ALL ON ALL SEQUENCES IN SCHEMA ${schema} TO ${var.bootstrap.owner};",
      "ALTER DEFAULT PRIVILEGES IN SCHEMA ${schema} GRANT ALL ON TABLES TO ${var.bootstrap.owner};",
    ]
  ])

  # Auto-append schema GRANTs and database GRANT to postInitApplicationSQL
  # Password is set via initdb.secret (not ALTER USER), avoiding PG18 scram bug
  post_init_application_sql = concat(
    lookup(var.bootstrap, "post_init_application_sql", []),
    local.init_schemas_grants,
    local.pooler_enabled ? [
      "GRANT ALL ON DATABASE ${var.bootstrap.database} TO ${var.bootstrap.owner};",
    ] : [],
  )
}

# Password secret (only created when not using an external secret)
resource "k8s_core_v1_secret" "password" {
  count = var.password_secret_name != null ? 0 : 1

  metadata {
    name      = "${var.name}-password"
    namespace = var.namespace
  }

  data = {
    "password" = base64encode(local.pg_password)
    "username" = base64encode("postgres")
  }

  type = "Opaque"
}

# Owner password secret for initdb.secret (CNPG handles the password correctly)
resource "k8s_core_v1_secret" "owner_password" {

  metadata {
    name      = local.owner_password_secret_name
    namespace = var.namespace
  }

  data = {
    "password" = base64encode(local.pg_password)
    "username" = base64encode(var.bootstrap.owner)
  }

  type = "Opaque"
}

# CloudNativePG Cluster
resource "k8s_postgresql_cnpg_io_v1_cluster" "this" {
  lifecycle {
    ignore_changes = [
      # CNPG injects runtime defaults into postgresql_parameters that we can't track in Terraform
      spec.0.postgresql.0.parameters
    ]
  }

  metadata {
    name      = var.name
    namespace = var.namespace
    labels = merge(
      {
        "cnpg.io/cluster"        = var.name
        "app.kubernetes.io/name" = var.name
      },
      var.inherited_metadata
    )
  }

  spec {
    instances   = var.instances
    description = var.description

    storage {
      size          = var.storage_size
      storage_class = var.storage_class
    }

    superuser_secret {
      name = local.password_secret_name
    }

    bootstrap {
      initdb {
        database                  = var.bootstrap.database
        owner                     = var.bootstrap.owner
        secret {
          name = local.owner_password_secret_name
        }
        post_init_application_sql = local.post_init_application_sql
      }
    }

    postgresql {
      parameters               = var.postgresql_parameters
      shared_preload_libraries = var.postgresql_shared_preload_libraries
      pg_hba                   = local.effective_pg_hba
    }

    image_name              = var.image_name
    enable_superuser_access = var.enable_superuser_access
    log_level               = "info"

    resources {
      limits   = { "memory" = var.resources.limits.memory }
      requests = { "cpu" = var.resources.requests.cpu, "memory" = var.resources.requests.memory }
    }

    affinity {
      enable_pod_anti_affinity = local.affinity_config.enable_pod_anti_affinity
      pod_anti_affinity_type   = local.affinity_config.pod_anti_affinity_type
      topology_key             = local.affinity_config.topology_key
      node_selector            = local.affinity_config.node_selector
    }

    max_sync_replicas = var.max_sync_replicas
    min_sync_replicas = var.min_sync_replicas

    replication_slots {
      high_availability {
        enabled = var.enable_replication_slots
      }
    }
  }
}

# PgBouncer Pooler (optional, enabled when pooler.name is provided)
resource "k8s_postgresql_cnpg_io_v1_pooler" "pooler" {
  count = local.pooler_enabled ? 1 : 0

  metadata {
    name      = local.pooler_name
    namespace = var.namespace
    labels = {
      "cnpg.io/poolerCluster" = var.name
    }
  }

  spec {
    cluster {
      name = var.name
    }

    instances = local.pooler_config.instances
    type      = "rw"

    deployment_strategy {
      type = "Recreate"
    }

    pgbouncer {
      pool_mode = local.pooler_config.pool_mode
      parameters = {
        "default_pool_size"  = "20"
        "max_client_conn"    = tostring(local.pooler_config.max_client_conn)
        "max_db_connections" = "100"
        "server_tls_sslmode" = "prefer"
      }

      pg_hba = local.effective_pooler_pg_hba
    }

    template {
      metadata {
        labels = {
          "cnpg.io/poolerCluster" = var.name
        }
      }
      spec {
        containers {
          name  = "pgbouncer"
          image = "ghcr.io/cloudnative-pg/pgbouncer:1.25.1"
          resources {
            limits   = { "memory" = "200Mi" }
            requests = { "cpu" = "100m", "memory" = "100Mi" }
          }
        }
      }
    }
  }
}

output "cluster_service_name" {
  description = "Primary read-write service name for direct PostgreSQL connections."
  value       = "${var.name}-rw"
}
