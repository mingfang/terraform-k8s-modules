locals {
  api_image             = "ghcr.io/hatchet-dev/hatchet/hatchet-api:v0.86.17"
  engine_image          = "ghcr.io/hatchet-dev/hatchet/hatchet-engine:v0.86.17"
  worker_image          = "ghcr.io/hatchet-dev/hatchet/hatchet-api:v0.86.17"
  dashboard_image       = "ghcr.io/hatchet-dev/hatchet/hatchet-dashboard:v0.86.17"
  hatchet_migrate_image = "ghcr.io/hatchet-dev/hatchet/hatchet-migrate:v0.86.17"
  admin_image           = "ghcr.io/hatchet-dev/hatchet/hatchet-admin:v0.86.17"

  grpc_broadcast_address = "${var.name}-engine.${module.namespace.name}.svc.cluster.local:7070"

  database_url = "postgresql://hatchet:${var.postgres_password}@${var.name}-postgres-rw.${module.namespace.name}.svc.cluster.local:5432/hatchet?sslmode=disable"

  rabbitmq_url = "amqp://${var.name}-rabbitmq.${module.namespace.name}.svc.cluster.local:5672"

  cookie_secrets = "${var.cookie_secret_1} ${var.cookie_secret_2}"
  cookie_domain  = ".${var.namespace}.rebelsoft.com"

  common_env_map = {
    SERVER_URL                     = "http://${var.name}-api.${module.namespace.name}.svc.cluster.local:8080"
    SERVER_PORT                    = "8080"
    SERVER_GRPC_PORT               = "7070"
    SERVER_GRPC_INSECURE           = "true"
    SERVER_GRPC_BROADCAST_ADDRESS  = local.grpc_broadcast_address
    SERVER_AUTH_BASIC_AUTH_ENABLED = "true"
    SERVER_AUTH_SET_EMAIL_VERIFIED = "true"
    SERVER_AUTH_COOKIE_SECRETS     = local.cookie_secrets
    SERVER_AUTH_COOKIE_DOMAIN      = local.cookie_domain
    SERVER_AUTH_COOKIE_INSECURE    = "true"
    SERVER_LOGGER_LEVEL            = "info"
    SERVER_LOGGER_FORMAT           = "console"
    DATABASE_LOGGER_LEVEL          = "info"
    DATABASE_LOGGER_FORMAT         = "console"
    SERVER_MSGQUEUE_KIND           = "rabbitmq"
    SERVER_MSGQUEUE_RABBITMQ_URL   = local.rabbitmq_url
    DATABASE_URL                   = local.database_url
  }
}

# ── Encryption Secret ──────────────────────────────────────────────────────────

resource "k8s_core_v1_secret" "encryption" {
  metadata {
    name      = "${var.name}-encryption"
    namespace = module.namespace.name
  }

  data = {
    "master.key"        = filebase64("${path.module}/keys/master.key")
    "public_ec256.key"  = filebase64("${path.module}/keys/public_ec256.key")
    "private_ec256.key" = filebase64("${path.module}/keys/private_ec256.key")
  }
}

# ── Namespace ─────────────────────────────────────────────────────────────────

module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

# ── CloudNativePG Cluster ─────────────────────────────────────────────────────

module "postgres" {
  source    = "../../modules/cloudnative-pg-cluster"
  name      = "${var.name}-postgres"
  namespace = module.namespace.name

  instances    = 2
  storage_size = "20Gi"
  image_name   = "registry.rebelsoft.com/cloudnative-vchord-suite:18.3-trixie"

  env_map = {
    "POSTGRES_PASSWORD" = var.postgres_password
  }

  bootstrap = {
    database = "hatchet"
    owner    = "hatchet"
  }

  postgresql_parameters = {
    max_connections              = "200"
    shared_buffers               = "256MB"
    effective_cache_size         = "1GB"
    maintenance_work_mem         = "64MB"
    checkpoint_completion_target = "0.9"
    wal_level                    = "replica"
    max_wal_senders              = "5"
    max_replication_slots        = "5"
  }
}

# ── RabbitMQ ──────────────────────────────────────────────────────────────────

module "rabbitmq" {
  source                 = "../../modules/rabbitmq"
  name                   = "${var.name}-rabbitmq"
  namespace              = module.namespace.name
  replicas               = 3
  image                  = "rabbitmq:3.13-management"
  RABBITMQ_ERLANG_COOKIE = var.erlang_cookie
  storage                = "10Gi"
  storage_class          = null

  resources = {
    requests = {
      cpu    = "500m"
      memory = "1Gi"
    }
    limits = {
      memory = "2Gi"
    }
  }
}

# ── API Deployment ────────────────────────────────────────────────────────────

module "api" {
  source    = "../../modules/generic-deployment-service"
  name      = "${var.name}-api"
  namespace = module.namespace.name
  image     = local.api_image
  replicas  = 1
  ports_map = { http = 8080, grpc = 7070 }

  env_map = local.common_env_map

  env = [
    { name = "SERVER_ENCRYPTION_MASTER_KEYSET", value_from = { secret_key_ref = { name = k8s_core_v1_secret.encryption.metadata[0].name, key = "master.key" } } },
    { name = "SERVER_ENCRYPTION_JWT_PUBLIC_KEYSET", value_from = { secret_key_ref = { name = k8s_core_v1_secret.encryption.metadata[0].name, key = "public_ec256.key" } } },
    { name = "SERVER_ENCRYPTION_JWT_PRIVATE_KEYSET", value_from = { secret_key_ref = { name = k8s_core_v1_secret.encryption.metadata[0].name, key = "private_ec256.key" } } }
  ]

  resources = {
    requests = { cpu = "500m", memory = "1Gi" }
    limits   = { cpu = "2", memory = "4Gi" }
  }
}

# ── Engine Deployment ─────────────────────────────────────────────────────────

module "engine" {
  source    = "../../modules/generic-deployment-service"
  name      = "${var.name}-engine"
  namespace = module.namespace.name
  image     = local.engine_image
  replicas  = 1

  env_map = local.common_env_map

  env = [
    { name = "SERVER_ENCRYPTION_MASTER_KEYSET", value_from = { secret_key_ref = { name = k8s_core_v1_secret.encryption.metadata[0].name, key = "master.key" } } },
    { name = "SERVER_ENCRYPTION_JWT_PUBLIC_KEYSET", value_from = { secret_key_ref = { name = k8s_core_v1_secret.encryption.metadata[0].name, key = "public_ec256.key" } } },
    { name = "SERVER_ENCRYPTION_JWT_PRIVATE_KEYSET", value_from = { secret_key_ref = { name = k8s_core_v1_secret.encryption.metadata[0].name, key = "private_ec256.key" } } }
  ]

  resources = {
    requests = { cpu = "1", memory = "2Gi" }
    limits   = { cpu = "4", memory = "8Gi" }
  }
}

# ── Frontend Deployment ───────────────────────────────────────────────────────

module "frontend" {
  source    = "../../modules/generic-deployment-service"
  name      = "${var.name}-frontend"
  namespace = module.namespace.name
  image     = local.dashboard_image
  replicas  = 1
  command   = ["sh", "/entrypoint.sh"]
  ports_map = { http = 80 }

  env_map = merge(local.common_env_map, {
    NEXT_PUBLIC_SERVER_URL = "https://${var.namespace}.rebelsoft.com"
  })

  env = [
    { name = "SERVER_ENCRYPTION_MASTER_KEYSET", value_from = { secret_key_ref = { name = k8s_core_v1_secret.encryption.metadata[0].name, key = "master.key" } } },
    { name = "SERVER_ENCRYPTION_JWT_PUBLIC_KEYSET", value_from = { secret_key_ref = { name = k8s_core_v1_secret.encryption.metadata[0].name, key = "public_ec256.key" } } },
    { name = "SERVER_ENCRYPTION_JWT_PRIVATE_KEYSET", value_from = { secret_key_ref = { name = k8s_core_v1_secret.encryption.metadata[0].name, key = "private_ec256.key" } } }
  ]

  resources = {
    requests = { cpu = "100m", memory = "256Mi" }
    limits   = { cpu = "500m", memory = "512Mi" }
  }
}

# ── Ingress ───────────────────────────────────────────────────────────────────

resource "k8s_networking_k8s_io_v1_ingress" "this" {
  metadata {
    name      = var.namespace
    namespace = module.namespace.name
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
  }

  spec {
    ingress_class_name = "nginx"
    rules {
      host = var.namespace
      http {
        paths {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = module.frontend.name
              port {
                number = module.frontend.ports_map.http
              }
            }
          }
        }

        paths {
          path      = "/api"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = module.api.name
              port {
                number = module.api.ports_map.http
              }
            }
          }
        }

        paths {
          path      = "/graphql"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = module.api.name
              port {
                number = module.api.ports_map.http
              }
            }
          }
        }
      }
    }
  }
}

# ── Migration Job ─────────────────────────────────────────────────────────────

resource "k8s_batch_v1_job" "migration" {
  metadata {
    name      = "${var.name}-migration"
    namespace = module.namespace.name
  }

  spec {
    backoff_limit              = 3
    active_deadline_seconds    = 300
    ttl_seconds_after_finished = 300

    template {
      metadata {}
      spec {
        restart_policy = "OnFailure"

        containers {
          name    = "${var.name}-migration"
          image   = local.hatchet_migrate_image
          command = ["/hatchet/hatchet-migrate"]

          env {
            name  = "DATABASE_URL"
            value = local.database_url
          }
        }
      }
    }
  }
}

# ── Seed Job ──────────────────────────────────────────────────────────────────

resource "k8s_batch_v1_job" "seed" {
  metadata {
    name      = "${var.name}-seed"
    namespace = module.namespace.name
  }

  spec {
    backoff_limit              = 1
    active_deadline_seconds    = 300
    ttl_seconds_after_finished = 300

    template {
      metadata {}
      spec {
        restart_policy = "OnFailure"

        containers {
          name    = "${var.name}-seed"
          image   = local.admin_image
          command = ["/hatchet/hatchet-admin", "seed"]

          env {
            name  = "DATABASE_URL"
            value = local.database_url
          }
          env {
            name  = "SERVER_AUTH_COOKIE_SECRETS"
            value = local.cookie_secrets
          }
          env {
            name  = "SERVER_AUTH_COOKIE_DOMAIN"
            value = local.cookie_domain
          }
          env {
            name  = "SERVER_AUTH_COOKIE_INSECURE"
            value = "true"
          }
          env {
            name  = "SERVER_AUTH_BASIC_AUTH_ENABLED"
            value = "true"
          }
          env {
            name  = "SERVER_AUTH_SET_EMAIL_VERIFIED"
            value = "true"
          }
          env {
            name  = "SERVER_MSGQUEUE_KIND"
            value = "rabbitmq"
          }
          env {
            name  = "SERVER_MSGQUEUE_RABBITMQ_URL"
            value = local.rabbitmq_url
          }
          env {
            name  = "ADMIN_EMAIL"
            value = "admin@example.com"
          }
          env {
            name  = "ADMIN_PASSWORD"
            value = "Admin123!!"
          }
          env {
            name  = "ADMIN_NAME"
            value = "Admin User"
          }
          env {
            name  = "DEFAULT_TENANT_NAME"
            value = "Default"
          }
          env {
            name  = "DEFAULT_TENANT_SLUG"
            value = "default"
          }
          env {
            name  = "DEFAULT_TENANT_ID"
            value = "707d0855-80ab-4e1f-a156-f1c4546cbf52"
          }
        }
      }
    }
  }
}
