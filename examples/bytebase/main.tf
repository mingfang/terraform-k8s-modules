module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

resource "k8s_core_v1_persistent_volume_claim" "data" {
  metadata {
    name      = var.name
    namespace = module.namespace.name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "s3fs"
  }
}

module "postgres" {
  source    = "../../modules/generic-statefulset-service"
  name      = "postgres"
  namespace = module.namespace.name
  image     = "postgres:17"
  ports     = [{ name = "tcp", port = 5432 }]
  storage   = "1Gi"

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
}

module "bytebase" {
  source    = "../../modules/generic-deployment-service"
  name      = "bytebase"
  namespace = module.namespace.name
  image     = "bytebase/bytebase"
  ports     = [{ name = "tcp", port = 8080 }]

  args = [
    "--port=8080",
    "--data=/var/opt/bytebase",
    "--pg=postgresql://postgres:postgres@${module.postgres.name}:${module.postgres.ports[0].port}/postgres",
    "--disable-sample",
    "--external-url=https://${var.namespace}.rebelsoft.com",
  ]

  pvcs = [
    {
      name       = k8s_core_v1_persistent_volume_claim.data.metadata[0].name
      mount_path = "/var/opt/bytebase"
    }
  ]
  pvc_user = ""
}

resource "k8s_networking_k8s_io_v1_ingress" "this" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/server-alias"       = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/proxy-read-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-send-timeout" = "3600"
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
              name = module.bytebase.name
              port {
                number = module.bytebase.ports[0].port
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