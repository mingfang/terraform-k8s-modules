resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

locals {
  jwt_secret = "XPZiTI3+T/yA+Akkym46fTX8y5gsaJaImAp9hC2YXWA="
}

module "postgres" {
  source    = "../../modules/postgres"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "registry.rebelsoft.com/supabase-postgres"
  replicas  = 1

  storage_class = "cephfs"
  storage       = "1Gi"

  POSTGRES_USER     = "postgres"
  POSTGRES_PASSWORD = "postgres"
  POSTGRES_DB       = "postgres"
}

module "realtime" {
  source    = "../../modules/supabase/realtime"
  name      = "realtime"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  JWT_SECRET = local.jwt_secret

  DB_HOST     = module.postgres.name
  DB_PORT     = module.postgres.ports[0].port
  DB_NAME     = "postgres"
  DB_USER     = "postgres"
  DB_PASSWORD = "postgres"
}

module "postgrest" {
  source    = "../../modules/postgrest"
  name      = "rest"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  PGRST_JWT_SECRET = local.jwt_secret
  PGRST_DB_URI     = "postgres://postgres:postgres@${module.postgres.name}:${module.postgres.ports[0].port}/postgres?sslmode=disable"
}

module "gotrue" {
  source    = "../../modules/supabase/gotrue"
  name      = "auth"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  GOTRUE_JWT_SECRET     = local.jwt_secret
  GOTRUE_OPERATOR_TOKEN = "secret123"

  API_EXTERNAL_URL = "https://${var.namespace}.rebelsoft.com"
  GOTRUE_SITE_URL  = "https://${var.namespace}.rebelsoft.com"

  DATABASE_URL = "postgres://postgres:postgres@${module.postgres.name}:${module.postgres.ports[0].port}/postgres?sslmode=disable"

  GOTRUE_SMTP_HOST = "smtp.gmail.com"
  GOTRUE_SMTP_PORT = 587
  GOTRUE_SMTP_USER = var.GOTRUE_SMTP_USER
  GOTRUE_SMTP_PASS = var.GOTRUE_SMTP_PASS
}

module "kong" {
  source    = "../../modules/supabase/kong"
  name      = "kong"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "kong" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.kong.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.kong.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.kong.name
            service_port = module.kong.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

