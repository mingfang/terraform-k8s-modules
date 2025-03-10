resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "k8s_core_v1_persistent_volume_claim" "bit-server-data" {
  metadata {
    name      = "bit-server-data"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}

module "bit-server" {
  source    = "../../modules/bit-server"
  name      = "bit-server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  pvc       = k8s_core_v1_persistent_volume_claim.bit-server-data.metadata[0].name

  scope-name = "my-scope"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.bit-server.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.bit-server.name
            service_port = module.bit-server.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
