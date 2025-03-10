resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "k8s_core_v1_persistent_volume_claim" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    storage_class_name = var.storage_class_name
    access_modes       = ["ReadWriteOnce"]

    resources {
      requests = { "storage" = "1Gi" }
    }
  }
}

module "user_secret" {
  source    = "../../modules/kubernetes/secret"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    GRID_USER     = base64encode("user")
    GRID_PASSWORD = base64encode("password")
  }
}

module "hub" {
  source             = "../../modules/zalenium"
  name               = var.name
  namespace          = k8s_core_v1_namespace.this.metadata[0].name
  pvc_name           = k8s_core_v1_persistent_volume_claim.this.metadata[0].name
  DESIRED_CONTAINERS = 1
  TZ                 = "America/New_York"
  //  user_secret_name = module.user_secret.name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.hub.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.hub.name}.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.hub.name
            service_port = 4444
          }
          path = "/"
        }
      }
    }
  }
}
