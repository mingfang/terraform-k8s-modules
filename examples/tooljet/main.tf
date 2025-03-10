module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

module "postgres" {
  source    = "../../modules/postgres"
  name      = "postgres"
  namespace = module.namespace.name
  image     = "postgres:16"

  args = [
    "-c", "work_mem=256MB",
    "-c", "maintenance_work_mem=256MB",
    "-c", "max_wal_size=1GB",
    "-c", "wal_level=logical",
  ]
  env_map = {
    POSTGRES_DB       = "postgres"
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
  }

  storage = "1Gi"
}

locals {
  # https://docs.tooljet.com/docs/setup/env-vars
  env = {
    TOOLJET_HOST       = "https://${var.namespace}.rebelsoft.com"
    LOCKBOX_MASTER_KEY = "29c6fc42469f56cfaa94c26aa05d96b0880fb5ab6cf9e6b3bb82ed4cb9497d59"
    SECRET_KEY_BASE    = "24fa7bac85c6f0692f2d0c808a0c37ec07747c680821757ed7e543d424269528"

    # db used by tooljet
    PG_HOST = module.postgres.name
    PG_DB   = "postgres"
    PG_USER = "postgres"
    PG_PASS = "postgres"

    # db used by postgrest, for user data
    # https://docs.tooljet.com/docs/tooljet-db/tooljet-database
    ENABLE_TOOLJET_DB = "true"
    TOOLJET_DB_HOST   = module.postgres.name
    TOOLJET_DB        = "tooljet_db"
    TOOLJET_DB_USER   = "postgres"
    TOOLJET_DB_PASS   = "postgres"
    PGRST_HOST        = "postgrest"
    PGRST_JWT_SECRET  = "24fa7bac85c6f0692f2d0c808a0c37ec07747c680821757ed7e543d424269528"
  }
}

module "tooljet" {
  source    = "../../modules/generic-deployment-service"
  name      = "tooljet"
  namespace = module.namespace.name
  image     = "tooljet/tooljet-ce:latest"

  ports = [{ name = "tcp", port = 80 }]
  command = ["sh", "-c", <<-EOF
    npm run db:create:prod
    npm run db:migrate:prod
    npm run start:prod
    EOF
  ]

  env_map = merge(local.env,
    {
      PORT                        = "80"
      SERVE_CLIENT                = "true"
      ENABLE_MULTIPLAYER_EDITING  = "true"
      COMMENT_FEATURE_ENABLE      = "true"
      ENABLE_MARKETPLACE_DEV_MODE = "true"
      ENABLE_PRIVATE_APP_EMBED    = "true"
      DEPLOYMENT_PLATFORM         = "k8s"
      ORM_LOGGING                 = "all"
    }
  )
}

module "postgrest" {
  source    = "../../modules/generic-deployment-service"
  name      = "postgrest"
  namespace = module.namespace.name
  image     = "postgrest/postgrest:v12.0.2"

  ports = [{ name = "tcp", port = 80 }]
  env_map = merge(local.env,
    {
      PGRST_SERVER_PORT   = "80"
      PGRST_DB_URI        = "postgres://postgres:postgres@${module.postgres.name}:5432/tooljet_db"
      PGRST_DB_POOL       = "10"
      PGRST_DB_PRE_CONFIG = "postgrest.pre_config"
      PGRST_LOG_LEVEL     = "info"
    }
  )
}

resource "k8s_networking_k8s_io_v1_ingress" "this" {
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
              name = module.tooljet.name
              port {
                number = module.tooljet.ports[0].port
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
