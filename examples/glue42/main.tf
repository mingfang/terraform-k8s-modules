resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "glue42" {
  source    = "../../modules/glue42"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = var.replicas
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.glue42.service.metadata[0].name
            service_port = module.glue42.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
