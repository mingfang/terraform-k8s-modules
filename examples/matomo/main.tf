resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}


module "mysql" {
  source        = "../../modules/mysql"
  name          = "mysql"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = "cephfs"
  storage       = "1Gi"
  replicas      = 1

  MYSQL_USER          = "matomo"
  MYSQL_PASSWORD      = "matomo"
  MYSQL_ROOT_PASSWORD = "mysql"
  MYSQL_DATABASE      = "matomo"
}

resource "k8s_core_v1_persistent_volume_claim" "this" {
  metadata {
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = "cephfs"

    resources {
      requests = { "storage" = "1Gi" }
    }
  }
}

module "matomo" {
  source    = "../../modules/matomo"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  MATOMO_DATABASE_HOST     = module.mysql.name
  MATOMO_DATABASE_DBNAME   = "matomo"
  MATOMO_DATABASE_USERNAME = "matomo"
  MATOMO_DATABASE_PASSWORD = "matomo"

  pvc_name = k8s_core_v1_persistent_volume_claim.this.metadata[0].name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "matomo-example.*"
    }
    name      = module.matomo.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.matomo.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.matomo.name
            service_port = module.matomo.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

