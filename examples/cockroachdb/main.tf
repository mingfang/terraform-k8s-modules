resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "cockroachdb" {
  source    = "../../modules/cockroachdb"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = var.replicas
  storage       = var.storage
  storage_class = var.storage_class
  annotations   = null
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.cockroachdb.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.cockroachdb.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.cockroachdb.name
            service_port = module.cockroachdb.ports[1].port
          }
          path = "/"
        }
      }
    }
  }
}
