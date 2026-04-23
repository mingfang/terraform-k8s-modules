module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

# Redis — queue and cache
module "redis" {
  source    = "../../modules/generic-deployment-service"
  name      = "redis"
  namespace = module.namespace.name
  image     = "redis:alpine"
  ports_map = { tcp = 6379 }

  args = ["redis-server", "--bind", "0.0.0.0"]

  replicas = 1
}

# Nuq Postgres — used for nuq-worker analytics
module "nuq-postgres" {
  source    = "../../modules/generic-statefulset-service"
  name      = "nuq-postgres"
  namespace = module.namespace.name
  image     = "ghcr.io/firecrawl/nuq-postgres:latest"
  ports_map = { tcp = 5432 }

  env_map = {
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "changeme"
    POSTGRES_DB       = "postgres"
  }

  storage    = "5Gi"
  mount_path = "/var/lib/postgresql/data"
}

# Playwright service — browser rendering for JS-heavy pages
module "playwright-service" {
  source    = "../../modules/generic-deployment-service"
  name      = "playwright-service"
  namespace = module.namespace.name
  image     = "ghcr.io/firecrawl/playwright-service:latest"
  ports_map = { http = 3000 }

  env_map = {
    PORT                        = "3000"
    ALLOW_LOCAL_WEBHOOKS        = "false"
    MAX_CONCURRENT_PAGES        = "10"
    PLAYWRIGHT_MICROSERVICE_URL = "http://playwright-service:3000"
  }

  liveness_probe = {
    initial_delay_seconds = 30
    period_seconds        = 30
    failure_threshold     = 3

    http_get = {
      path = "/health"
      port = 3000
    }
  }

  resources = {
    requests = {
      memory = "2Gi"
      cpu    = "1000m"
    }
    limits = {
      memory = "4Gi"
      cpu    = "2000m"
    }
  }
}

# API — main Firecrawl REST API server
module "api" {
  source    = "../../modules/generic-deployment-service"
  name      = "api"
  namespace = module.namespace.name
  image     = "ghcr.io/firecrawl/firecrawl:latest"
  ports_map = { http = 3002 }

  command = ["node"]
  args    = ["--max-old-space-size=6144", "dist/src/index.js"]

  env_map = {
    HOST                        = "0.0.0.0"
    PORT                        = "3002"
    REDIS_URL                   = "redis://redis:6379"
    REDIS_RATE_LIMIT_URL        = "redis://redis:6379"
    PLAYWRIGHT_MICROSERVICE_URL = "http://playwright-service:3000/scrape"
    USE_DB_AUTHENTICATION       = "false"
    NUQ_DATABASE_URL            = "postgresql://postgres:changeme@nuq-postgres:5432/postgres"
    BULL_AUTH_KEY               = "changeme"
  }

  liveness_probe = {
    initial_delay_seconds = 30
    period_seconds        = 30
    failure_threshold     = 3
    timeout_seconds       = 5

    http_get = {
      path = "/v0/health/liveness"
      port = 3002
    }
  }

  readiness_probe = {
    initial_delay_seconds = 30
    period_seconds        = 30
    failure_threshold     = 3
    timeout_seconds       = 5

    http_get = {
      path = "/v0/health/readiness"
      port = 3002
    }
  }

  resources = {
    requests = {
      memory = "4Gi"
      cpu    = "2000m"
    }
    limits = {
      memory = "6Gi"
      cpu    = "2000m"
    }
  }
}

# Worker — queue job processor
module "worker" {
  source    = "../../modules/generic-deployment-service"
  name      = "worker"
  namespace = module.namespace.name
  image     = "ghcr.io/firecrawl/firecrawl:latest"
  ports_map = { http = 3005 }

  command = ["node"]
  args    = ["--max-old-space-size=3072", "dist/src/services/queue-worker.js"]

  env_map = {
    HOST                        = "0.0.0.0"
    PORT                        = "3005"
    REDIS_URL                   = "redis://redis:6379"
    REDIS_RATE_LIMIT_URL        = "redis://redis:6379"
    PLAYWRIGHT_MICROSERVICE_URL = "http://playwright-service:3000/scrape"
    USE_DB_AUTHENTICATION       = "false"
    NUQ_DATABASE_URL            = "postgresql://postgres:changeme@nuq-postgres:5432/postgres"
    BULL_AUTH_KEY               = "changeme"
  }

  liveness_probe = {
    initial_delay_seconds = 5
    period_seconds        = 5
    failure_threshold     = 3
    timeout_seconds       = 5

    http_get = {
      path = "/liveness"
      port = 3005
    }
  }

  resources = {
    requests = {
      memory = "3Gi"
      cpu    = "1000m"
    }
    limits = {
      memory = "4Gi"
      cpu    = "1000m"
    }
  }
}

# Ingress — exposes the API
resource "k8s_networking_k8s_io_v1_ingress" "api" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = "${var.namespace}-api"
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
              name = module.api.name
              port {
                number = module.api.ports_map.http
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
