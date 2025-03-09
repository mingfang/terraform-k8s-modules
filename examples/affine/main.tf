module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

module "postgres" {
  source    = "../../modules/generic-statefulset-service"
  name      = "postgres"
  namespace = module.namespace.name
  image     = "postgres:17"
  ports     = [{ name = "tcp", port = 5432 }]
  storage   = "1Gi"

  env_map = {
    POSTGRES_DB       = "postgres"
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
  }
}

module "redis" {
  source    = "../../modules/generic-deployment-service"
  name      = "redis"
  namespace = module.namespace.name
  image     = "redis"
  ports     = [{ name = "tcp", port = 6379 }]
}

module "affine" {
  source    = "../../modules/generic-deployment-service"
  name      = var.name
  namespace = module.namespace.name
  image     = "ghcr.io/toeverything/affine-graphql:stable"
  ports     = [{ name = "tcp", port = 3010 }]
  command   = []
  args      = []

  env_map = {
    REDIS_SERVER_HOST = module.redis.name
    DATABASE_URL      = "postgresql://postgres:postgres@${module.postgres.name}:${module.postgres.ports[0].port}/postgres"
  }

  init_containers = [
    {
      name  = "migration"
      image = "ghcr.io/toeverything/affine-graphql:stable"
      command = ["sh", "-c", <<-EOF
      node ./scripts/self-host-predeploy.js
      EOF
      ]
      env = [
        {
          name  = "REDIS_SERVER_HOST"
          value = module.redis.name

        },
        {
          name  = "DATABASE_URL"
          value = "postgresql://postgres:postgres@${module.postgres.name}:${module.postgres.ports[0].port}/postgres"
        },
      ]
    }

  ]
}

resource "k8s_networking_k8s_io_v1_ingress" "affine" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.namespace
    namespace = module.namespace.name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.affine.name
              port {
                number = module.affine.ports.0.port
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
