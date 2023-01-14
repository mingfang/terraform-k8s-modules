resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "postgres" {
  source    = "../../modules/postgres"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  storage_class = "cephfs"
  storage       = "1Gi"

  env_map = {
    POSTGRES_DB       = "tooljet_production"
    POSTGRES_USER     = "tooljet"
    POSTGRES_PASSWORD = "tooljet"
  }
}

resource "random_password" "LOCKBOX_MASTER_KEY" {
  length  = 32
  special = false
}

resource "random_password" "SECRET_KEY_BASE" {
  length  = 64
  special = false
}

module "tooljet-server" {
  source    = "../../modules/tooljet/server"
  name      = "tooljet-server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  PG_HOST            = module.postgres.name
  PG_DB              = "tooljet_production"
  PG_USER            = "tooljet"
  PG_PASS            = "tooljet"
  LOCKBOX_MASTER_KEY = base64encode(random_password.LOCKBOX_MASTER_KEY.result)
  SECRET_KEY_BASE    = base64encode(random_password.SECRET_KEY_BASE.result)
  TOOLJET_HOST       = "https://tooljet-example.rebelsoft.com"
  SERVE_CLIENT       = "true"
}

module "tooljet-client" {
  source    = "../../modules/tooljet/client"
  name      = "tooljet-client"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  SERVER_HOST = module.tooljet-server.name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "tooljet" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.tooljet-client.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.tooljet-client.name
            service_port = module.tooljet-client.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
