resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "postgres" {
  source    = "../../modules/postgres"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  image = "registry.rebelsoft.com/postgres:16"

  args = [
    "-c", "work_mem=512MB",
    "-c", "maintenance_work_mem=512MB",
    "-c", "max_wal_size=1GB",
    "-c", "wal_level=logical",
    "-c", "log_statement=all",
    "-c", "max_worker_processes=128",
  ]

  env_map = {
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
    POSTGRES_DB       = "postgres"
  }

  storage       = "1Gi"
  storage_class = "cephfs-csi"
}

module "temporal" {
  source    = "../../modules/generic-deployment-service"
  name      = "temporal"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  # https://hub.docker.com/r/temporalio/auto-setup/tags
  image     = "temporalio/auto-setup:1.24.2"
  ports     = [{ name = "tcp", port = 7233 }]

  env_map = {
    DB             = "postgres12"
    DB_PORT        = "5432"
    POSTGRES_USER  = "postgres"
    POSTGRES_PWD   = "postgres"
    POSTGRES_SEEDS = "postgres"
  }
}

module "temporal-ui" {
  source    = "../../modules/generic-deployment-service"
  name      = "temporal-ui"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  # https://hub.docker.com/r/temporalio/ui/tags
  image     = "temporalio/ui:2.29.2"
  ports     = [{ name = "tcp", port = 8080 }]

  env_map = {
    TEMPORAL_ADDRESS = "temporal:7233"
  }
}

resource "k8s_networking_k8s_io_v1_ingress" "temporal" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.namespace
    namespace = k8s_core_v1_namespace.this.metadata.0.name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.temporal-ui.name
              port {
                number = module.temporal-ui.ports.0.port
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
