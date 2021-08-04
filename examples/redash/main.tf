resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "redis" {
  source    = "../../modules/redis"
  name      = "redis"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas = 1
}

module "postgres" {
  source        = "../../modules/postgres"
  name          = "postgres"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = "cephfs"
  storage       = "1Gi"
  replicas      = 1

  POSTGRES_USER     = "redash"
  POSTGRES_PASSWORD = "redash"
  POSTGRES_DB       = "redash"
}

module "server" {
  source    = "../../modules/redash/server"
  name      = "server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  REDASH_REDIS_URL    = "redis://${module.redis.name}:${module.redis.ports[0].port}"
  REDASH_DATABASE_URL = "postgresql://redash:redash@${module.postgres.name}:${module.postgres.ports[0].port}"
}

module "scheduler" {
  source    = "../../modules/redash/scheduler"
  name      = "scheduler"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  REDASH_REDIS_URL    = "redis://${module.redis.name}:${module.redis.ports[0].port}"
  REDASH_DATABASE_URL = "postgresql://redash:redash@${module.postgres.name}:${module.postgres.ports[0].port}"
}

module "worker-scheduled" {
  source    = "../../modules/redash/worker"
  name      = "worker-scheduled"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  REDASH_REDIS_URL    = "redis://${module.redis.name}:${module.redis.ports[0].port}"
  REDASH_DATABASE_URL = "postgresql://redash:redash@${module.postgres.name}:${module.postgres.ports[0].port}"
}

module "worker-adhoc" {
  source    = "../../modules/redash/worker"
  name      = "worker-adhoc"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  QUEUES        = "queries"
  WORKERS_COUNT = 2

  REDASH_REDIS_URL    = "redis://${module.redis.name}:${module.redis.ports[0].port}"
  REDASH_DATABASE_URL = "postgresql://redash:redash@${module.postgres.name}:${module.postgres.ports[0].port}"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.server.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.name}.${var.namespace}"
      http {
        paths {
          path = "/"
          backend {
            service_name = module.server.name
            service_port = module.server.ports[0].port
          }
        }
      }
    }
  }
}


