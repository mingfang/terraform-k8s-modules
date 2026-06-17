resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "vpa-recommender" {
  source    = "../../modules/kubernetes/vpa-recommender"
  name      = "vpa-recommender"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "goldilocks-controller" {
  source    = "../../modules/goldilocks/controller"
  name      = "goldilocks-controller"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "goldilocks-dashboard" {
  source    = "../../modules/goldilocks/dashboard"
  name      = "goldilocks-dashboard"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

resource "k8s_networking_k8s_io_v1_ingress" "this" {
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
    ingress_class_name = "nginx"
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.goldilocks-dashboard.name
              port {
                number = module.goldilocks-dashboard.ports[0].port
              }
            }
          }
          path      = "/"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}
