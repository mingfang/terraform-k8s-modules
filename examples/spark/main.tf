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
    storage_class_name = "cephfs"
  }
}

module "master" {
  source    = "../../modules/spark/master"
  name      = "${var.name}-master"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "worker" {
  source     = "../../modules/spark/worker"
  name       = "${var.name}-worker"
  namespace  = k8s_core_v1_namespace.this.metadata[0].name
  replicas = 2

  master_url = module.master.master_url
}

module "ui-proxy" {
  source      = "../../modules/spark/ui-proxy"
  name        = "${var.name}-ui-proxy"
  namespace   = k8s_core_v1_namespace.this.metadata[0].name
  master_host = module.master.service.metadata[0].name
  master_port = module.master.service.spec[0].ports[1].port
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "ui-proxy" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"    = "${var.namespace}.*"
    }
    name      = module.ui-proxy.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.ui-proxy.name
            service_port = module.ui-proxy.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
