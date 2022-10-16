resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "postgres" {
  source    = "../../modules/postgres"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  storage_class = "cephfs"
  storage       = "1Gi"

  POSTGRES_USER     = "postgres"
  POSTGRES_PASSWORD = "postgres"
  POSTGRES_DB       = "postgres"
}

module "lightdash" {
  source    = "../../modules/lightdash"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env_map = {
    "PGHOST"              = module.postgres.name
    "PGPORT"              = module.postgres.ports[0].port
    "PGUSER"              = "postgres"
    "PGPASSWORD"          = "postgres"
    "PGDATABASE"          = "postgres"
    "LIGHTDASH_SECRET"    = "lightdashsecret"
    "LIGHTDASH_LOG_LEVEL" = "debug"
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.namespace
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.lightdash.name
            service_port = module.lightdash.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
