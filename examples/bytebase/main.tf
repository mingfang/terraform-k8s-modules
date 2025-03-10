resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "k8s_core_v1_persistent_volume_claim" "data" {
  metadata {
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "s3fs"
  }
}

module "postgres" {
  source    = "../../modules/postgres"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  storage_class = "cephfs"
  storage       = "1Gi"

  image = "postgres:16"

  args = [
    "-c", "work_mem=256MB",
    "-c", "maintenance_work_mem=256MB",
    "-c", "max_wal_size=1GB",
    "-c", "wal_level=logical",
  ]
  env_map = {
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
    POSTGRES_DB       = "postgres"
  }
}

module "bytebase" {
  source    = "../../modules/bytebase"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  pvcs = [
    {
      name = k8s_core_v1_persistent_volume_claim.data.metadata[0].name
      mount_path = "/var/opt/bytebase"
    }
  ]
  pvc_user = ""
  args = split(" ","--port 8080 --data /var/opt/bytebase --pg postgresql://postgres:postgres@${module.postgres.name}:${module.postgres.ports[0].port}/postgres --disable-sample --external-url https://bytebase-example.rebelsoft.com" )
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
            service_name = module.bytebase.name
            service_port = module.bytebase.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
