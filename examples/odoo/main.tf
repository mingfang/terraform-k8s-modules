resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "postgres" {
  source        = "../../modules/postgres"
  name          = "postgres"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = var.storage_class
  storage       = "1Gi"
  replicas      = 1

  POSTGRES_USER     = "odoo"
  POSTGRES_PASSWORD = "odoo"
  POSTGRES_DB       = "postgres"
}

resource "k8s_core_v1_persistent_volume_claim" "data" {
  metadata {
    name      = "data"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = [
    "ReadWriteMany"]
    resources {
      requests = {
        "storage" = "1Gi"
      }
    }
    storage_class_name = var.storage_class
  }
}

module "odoo" {
  source    = "../../modules/odoo"
  name      = "odoo"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  pvc = k8s_core_v1_persistent_volume_claim.data.metadata[0].name

  HOST     = module.postgres.name
  USER     = "odoo"
  PASSWORD = "odoo"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "odoo" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "odoo-example.*"
    }
    name      = module.odoo.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.name}.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.odoo.name
            service_port = module.odoo.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

