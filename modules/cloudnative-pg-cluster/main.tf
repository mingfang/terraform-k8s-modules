locals {
  password_secret_name       = var.password_secret_name != null ? var.password_secret_name : "${var.name}-password"
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
  pooler_pg_hba           = local.pooler_config.pg_hba
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

# Barman Cloud Plugin operator installation
resource "null_resource" "barman_cloud_operator" {
  count = local.barman_cloud_enabled ? 1 : 0

  provisioner "local-exec" {
    command = <<-EOT
      curl -fsSL "https://github.com/cloudnative-pg/plugin-barman-cloud/releases/download/v${var.barman_cloud_plugin_version}/manifest.yaml" | \
      kubectl apply -f -
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      curl -fsSL "https://github.com/cloudnative-pg/plugin-barman-cloud/releases/download/v${self.triggers.barman_cloud_plugin_version}/manifest.yaml" | \
      kubectl delete --ignore-not-found=true -f -
    EOT
  }

  triggers = {
    barman_cloud_plugin_version = var.barman_cloud_plugin_version
  }
}

# Barman Cloud Plugin: ObjectStore resource (applied via kubectl since the CRD
# is installed by the operator null_resource and the provider discovers schemas at init time)
resource "null_resource" "barman_object_store" {
  count = local.barman_cloud_enabled ? 1 : 0

  depends_on = [null_resource.barman_cloud_operator]

  triggers = {
    name              = local.barman_object_store_name
    namespace         = var.namespace
    object_store_yaml = local.barman_object_store_yaml
  }

  provisioner "local-exec" {
    command    = <<-EOT
      kubectl apply -f - <<'YAML'
      ${local.barman_object_store_yaml}
      YAML
    EOT
    when       = create
    on_failure = continue
  }

  provisioner "local-exec" {
    command    = <<-EOT
      kubectl apply -f - <<'YAML'
${local.barman_object_store_yaml}
YAML
    EOT
    when       = create
    on_failure = continue
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete objectstore.barmancloud.cnpg.io \"${self.triggers.name}\" -n ${self.triggers.namespace} --ignore-not-found=true"
  }
}

locals {
  barman_cloud_enabled = var.barman_cloud.enabled

  # Merge user-provided barman_cloud config with defaults
  barman_cloud_config = merge({
    name                       = null
    destination_path           = null
    endpoint_url               = null
    s3_credentials_secret_name = null
    s3_region                  = null
    inherit_from_iam_role      = false
    wal_compression            = null
    wal_max_parallel           = null
    wal_encryption             = null
    data_compression           = null
    data_encryption            = null
    data_jobs                  = null
    data_immediate_checkpoint  = null
    retention_policy           = null
    sidecar_resources          = {}
    sidecar_retention_interval = 1800
  }, var.barman_cloud)

  # Merge user-provided scheduled_backup config with defaults
  scheduled_backup_config = merge({
    enabled                = false
    schedule               = "0 0 0 * * *"
    immediate              = false
    backup_owner_reference = "none"
  }, var.scheduled_backup)

  barman_object_store_name   = local.barman_cloud_config.name != null ? local.barman_cloud_config.name : "${var.name}-backup"
  barman_cloud_enabled_count = local.barman_cloud_enabled ? 1 : 0

  plugins_config = local.barman_cloud_enabled ? [
    {
      name            = "barman-cloud.cloudnative-pg.io"
      is_wal_archiver = true
      parameters = {
        barmanObjectName = local.barman_object_store_name
      }
    }
  ] : []

  # Build the ObjectStore YAML as a string for kubectl apply
  barman_object_store_yaml = local.barman_cloud_enabled ? join("", [
    "apiVersion: barmancloud.cnpg.io/v1\n",
    "kind: ObjectStore\n",
    "metadata:\n",
    "  name: ${local.barman_object_store_name}\n",
    "  namespace: ${var.namespace}\n",
    "spec:\n",
    "  configuration:\n",
    "    destinationPath: ${local.barman_cloud_config.destination_path}\n",
    local.barman_cloud_config.endpoint_url != null ? "    endpointURL: ${local.barman_cloud_config.endpoint_url}\n" : "",
    local.barman_cloud_config.s3_credentials_secret_name != null && !local.barman_cloud_config.inherit_from_iam_role ? join("", [
      "    s3Credentials:\n",
      "      accessKeyId:\n",
      "        name: ${local.barman_cloud_config.s3_credentials_secret_name}\n",
      "        key: ACCESS_KEY_ID\n",
      "      secretAccessKey:\n",
      "        name: ${local.barman_cloud_config.s3_credentials_secret_name}\n",
      "        key: ACCESS_SECRET_KEY\n",
      local.barman_cloud_config.s3_region != null ? "          region:\n            name: ${local.barman_cloud_config.s3_credentials_secret_name}\n            key: REGION\n" : "",
    ]) : "",
    local.barman_cloud_config.inherit_from_iam_role ? "    s3Credentials:\n      inheritFromIAMRole: true\n" : "",
    (local.barman_cloud_config.wal_compression != null || local.barman_cloud_config.wal_max_parallel != null || local.barman_cloud_config.wal_encryption != null) ? join("", [
      "    wal:\n",
      local.barman_cloud_config.wal_compression != null ? "      compression: ${local.barman_cloud_config.wal_compression}\n" : "",
      local.barman_cloud_config.wal_max_parallel != null ? "      maxParallel: ${local.barman_cloud_config.wal_max_parallel}\n" : "",
      local.barman_cloud_config.wal_encryption != null ? "      encryption: ${local.barman_cloud_config.wal_encryption}\n" : "",
    ]) : "",
    (local.barman_cloud_config.data_compression != null || local.barman_cloud_config.data_encryption != null || local.barman_cloud_config.data_jobs != null || local.barman_cloud_config.data_immediate_checkpoint != null) ? join("", [
      "    data:\n",
      local.barman_cloud_config.data_compression != null ? "      compression: ${local.barman_cloud_config.data_compression}\n" : "",
      local.barman_cloud_config.data_encryption != null ? "      encryption: ${local.barman_cloud_config.data_encryption}\n" : "",
      local.barman_cloud_config.data_jobs != null ? "      jobs: ${local.barman_cloud_config.data_jobs}\n" : "",
      local.barman_cloud_config.data_immediate_checkpoint != null ? "      immediateCheckpoint: ${local.barman_cloud_config.data_immediate_checkpoint}\n" : "",
    ]) : "",
    local.barman_cloud_config.retention_policy != null ? "  retentionPolicy: \"${local.barman_cloud_config.retention_policy}\"\n" : "",
    (length(local.barman_cloud_config.sidecar_resources) > 0 || local.barman_cloud_config.sidecar_retention_interval != 1800) ? join("", [
      "  instanceSidecarConfiguration:\n",
      "    retentionPolicyIntervalSeconds: ${local.barman_cloud_config.sidecar_retention_interval}\n",
    ]) : "",
  ]) : ""
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
        database = var.bootstrap.database
        owner    = var.bootstrap.owner
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

    dynamic "plugins" {
      for_each = local.plugins_config
      content {
        name           = plugins.value.name
        iswal_archiver = plugins.value.is_wal_archiver
        parameters     = plugins.value.parameters
      }
    }
  }
}

# Scheduled Backup (optional, enabled when scheduled_backup.enabled is true)
resource "k8s_postgresql_cnpg_io_v1_scheduled_backup" "scheduled" {
  count = local.scheduled_backup_config.enabled ? 1 : 0

  metadata {
    name      = "${var.name}-scheduled-backup"
    namespace = var.namespace
  }

  spec {
    schedule  = local.scheduled_backup_config.schedule
    immediate = local.scheduled_backup_config.immediate
    cluster {
      name = var.name
    }
    backup_owner_reference = local.scheduled_backup_config.backup_owner_reference
    method                 = "plugin"
    plugin_configuration {
      name = "barman-cloud.cloudnative-pg.io"
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
