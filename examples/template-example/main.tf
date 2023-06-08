resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "{{name}}" {
  source    = "../../modules/{{name}}"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
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
            service_name = module.{{name}}.name
            service_port = module.{{name}}.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
