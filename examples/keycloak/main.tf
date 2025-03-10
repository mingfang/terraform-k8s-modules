resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "postgres" {
  source        = "../../modules/postgres"
  name          = "postgres"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = "cephfs"
  storage       = "1Gi"
  replicas      = 1
  image         = "postgres:9.6.16"

  env_map = {
    POSTGRES_USER     = "keycloak"
    POSTGRES_PASSWORD = "keycloak"
    POSTGRES_DB       = "keycloak"
  }
}

module "keycloak" {
  source    = "../../modules/keycloak"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  KEYCLOAK_USER     = "keycloak"
  KEYCLOAK_PASSWORD = "keycloak"
  DB_VENDOR         = "postgres"
  DB_ADDR           = "${module.postgres.name}:${module.postgres.ports.0.port}"
  DB_USER           = "keycloak"
  DB_PASSWORD       = "keycloak"
  DB_DATABASE       = "keycloak"
  DB_SCHEMA         = "public"
}

resource "k8s_extensions_v1beta1_ingress" "keycloak" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.keycloak.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.keycloak.name
            service_port = module.keycloak.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

