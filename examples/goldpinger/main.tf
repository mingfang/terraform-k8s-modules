resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }

    name = var.namespace
  }
}

module "goldpinger" {
  source    = "../../modules/goldpinger"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

resource "k8s_extensions_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.name}.*"
    }
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.name
      http {
        paths {
          backend {
            service_name = module.goldpinger.name
            service_port = module.goldpinger.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
