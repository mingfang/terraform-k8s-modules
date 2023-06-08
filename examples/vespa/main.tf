resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "vespa" {
  source    = "../../modules/vespa"
  name      = "vespa"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 2

  storage_class = "cephfs"
  storage       = "1Gi"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.vespa.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.vespa.name
            service_port = module.vespa.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
