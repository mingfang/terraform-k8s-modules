module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

module "minio" {
  source    = "../../modules/generic-statefulset-service"
  name      = "minio"
  namespace = module.namespace.name
  image     = "minio/minio:latest"
  args      = ["server", "/data", "--console-address", ":9001"]
  ports     = [{ name = "s3", port = 9000 }]

  env_map = {
    MINIO_ROOT_USER    = var.minio_access_key
    MINIO_ROOT_PASSWORD = var.minio_secret_key
  }

  storage    = "5Gi"
  mount_path = "/data"
}

module "redis" {
  source    = "../../modules/generic-statefulset-service"
  name      = "redis"
  namespace = module.namespace.name
  image     = "redis:7-alpine"
  ports     = [{ name = "tcp", port = 6379 }]

  storage    = "1Gi"
  mount_path = "/data"
}

module "postgres" {
  source    = "../../modules/generic-statefulset-service"
  name      = "postgres"
  namespace = module.namespace.name
  image     = "postgres:17-alpine"
  ports_map = { tcp = 5432 }

  env_map = {
    POSTGRES_DB       = var.postgres_db
    POSTGRES_USER     = var.postgres_user
    POSTGRES_PASSWORD = var.postgres_password
  }

  storage    = "5Gi"
  mount_path = "/var/lib/postgresql/data"
}

module "buzz" {
  source    = "../../modules/generic-deployment-service"
  name      = var.name
  namespace = module.namespace.name
  image     = "ghcr.io/block/buzz:latest"
  ports = [
    { name = "http", port = 3000 },
    { name = "health", port = 8080 },
  ]

  env_map = {
    RELAY_URL           = "wss://buzz-example.rebelsoft.com"
    BUZZ_MEDIA_BASE_URL = "https://buzz-example.rebelsoft.com/media"

    DATABASE_URL        = "postgres://${var.postgres_user}:${var.postgres_password}@${module.postgres.name}:5432/${var.postgres_db}"
    BUZZ_AUTO_MIGRATE   = "true"
    REDIS_URL           = "redis://${module.redis.name}:6379"
    BUZZ_BIND_ADDR      = "0.0.0.0:3000"
    RUST_LOG            = "buzz_relay=info,buzz_db=info,buzz_auth=info,buzz_pubsub=info"

    BUZZ_S3_ENDPOINT    = "http://${module.minio.name}:9000"
    BUZZ_S3_ACCESS_KEY  = var.minio_access_key
    BUZZ_S3_SECRET_KEY  = var.minio_secret_key
    BUZZ_S3_BUCKET      = "buzz-media"
    BUZZ_S3_REGION      = "us-east-1"
  }

  liveness_probe = {
    initial_delay_seconds = 30
    period_seconds        = 30
    failure_threshold     = 3
    http_get = {
      path = "/_liveness"
      port = 8080
    }
  }

  readiness_probe = {
    initial_delay_seconds = 10
    period_seconds        = 10
    failure_threshold     = 3
    http_get = {
      path = "/_readiness"
      port = 8080
    }
  }

  resources = {
    requests = {
      cpu    = "500m"
      memory = "512Mi"
    }
    limits = {
      memory = "1Gi"
    }
  }
}

# ── S3 Bucket Init Job ────────────────────────────────────────────────────────
# Creates the buzz-media bucket in MinIO so the relay can start.
# Matches the docker-compose minio-init service.

resource "k8s_batch_v1_job" "buzz_bucket_init" {
  metadata {
    name      = "${var.name}-bucket-init"
    namespace = module.namespace.name
  }

  spec {
    backoff_limit              = 3
    active_deadline_seconds    = 60
    ttl_seconds_after_finished = 300

    template {
      metadata {}

      spec {
        restart_policy = "OnFailure"

        containers {
          name    = "mc"
          image   = "minio/mc:latest"
          command = [
            "/bin/sh",
            "-c",
            "mc alias set minio http://minio:9000 ${var.minio_access_key} ${var.minio_secret_key} && mc mb --ignore-existing minio/buzz-media"
          ]
        }
      }
    }
  }
}

resource "k8s_networking_k8s_io_v1_ingress" "this" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.namespace
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
              name = module.buzz.name
              port {
                number = module.buzz.ports_map.http
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
