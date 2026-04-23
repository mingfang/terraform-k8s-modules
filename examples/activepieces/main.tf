module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

# Redis — caching and job queue
module "redis" {
  source    = "../../modules/generic-deployment-service"
  name      = "redis"
  namespace = module.namespace.name
  image     = "redis:7.0.7"
  ports_map = { tcp = 6379 }

  replicas = 1
}

# Postgres with pgvector — primary database + vector embeddings
module "postgres" {
  source    = "../../modules/generic-statefulset-service"
  name      = "postgres"
  namespace = module.namespace.name
  image     = "pgvector/pgvector:0.8.0-pg14"
  ports_map = { tcp = 5432 }

  env_map = {
    POSTGRES_DB       = var.AP_POSTGRES_DATABASE
    POSTGRES_USER     = var.AP_POSTGRES_USERNAME
    POSTGRES_PASSWORD = var.AP_POSTGRES_PASSWORD
  }

  storage    = "10Gi"
  mount_path = "/var/lib/postgresql/data"
}

# App — main Activepieces web/API server
module "app" {
  source    = "../../modules/generic-deployment-service"
  name      = "app"
  namespace = module.namespace.name
  image     = "ghcr.io/activepieces/activepieces:0.80.1"
  ports_map = { http = 80 }

  env_map = {
    AP_CONTAINER_TYPE                = "APP"
    AP_ENCRYPTION_KEY                = var.AP_ENCRYPTION_KEY
    AP_JWT_SECRET                    = var.AP_JWT_SECRET
    AP_ENVIRONMENT                   = "prod"
    AP_FRONTEND_URL                  = "https://${var.namespace}.rebelsoft.com"
    AP_WEBHOOK_TIMEOUT_SECONDS       = "30"
    AP_TRIGGER_DEFAULT_POLL_INTERVAL = "5"
    AP_POSTGRES_DATABASE             = var.AP_POSTGRES_DATABASE
    AP_POSTGRES_HOST                 = "postgres"
    AP_POSTGRES_PORT                 = "5432"
    AP_POSTGRES_USERNAME             = var.AP_POSTGRES_USERNAME
    AP_POSTGRES_PASSWORD             = var.AP_POSTGRES_PASSWORD
    AP_EXECUTION_MODE                = "UNSANDBOXED"
    AP_REDIS_HOST                    = "redis"
    AP_REDIS_PORT                    = "6379"
    AP_FLOW_TIMEOUT_SECONDS          = "600"
    AP_TELEMETRY_ENABLED             = "true"
  }

  liveness_probe = {
    initial_delay_seconds = 30
    period_seconds        = 30
    failure_threshold     = 3

    http_get = {
      path = "/health"
      port = 80
    }
  }

  readiness_probe = {
    initial_delay_seconds = 30
    period_seconds        = 30
    failure_threshold     = 3

    http_get = {
      path = "/health"
      port = 80
    }
  }
}

# Worker — background job processor
module "worker" {
  source    = "../../modules/generic-deployment-service"
  name      = "worker"
  namespace = module.namespace.name
  image     = "ghcr.io/activepieces/activepieces:0.80.1"
  ports_map = { http = 80 }

  env_map = {
    AP_CONTAINER_TYPE       = "WORKER"
    AP_ENVIRONMENT          = "prod"
    AP_FRONTEND_URL         = "http://app:80"
    AP_WORKER_TOKEN         = var.AP_WORKER_TOKEN
    AP_POSTGRES_DATABASE    = var.AP_POSTGRES_DATABASE
    AP_POSTGRES_HOST        = "postgres"
    AP_POSTGRES_PORT        = "5432"
    AP_POSTGRES_USERNAME    = var.AP_POSTGRES_USERNAME
    AP_POSTGRES_PASSWORD    = var.AP_POSTGRES_PASSWORD
    AP_REDIS_HOST           = "redis"
    AP_REDIS_PORT           = "6379"
    AP_EXECUTION_MODE       = "UNSANDBOXED"
    AP_FLOW_TIMEOUT_SECONDS = "600"
  }
}

# Ingress — exposes the web UI and API
resource "k8s_networking_k8s_io_v1_ingress" "app" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = "${var.namespace}-app"
    namespace = module.namespace.name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.app.name
              port {
                number = module.app.ports_map.http
              }
            }
          }
          path      = "/"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}
