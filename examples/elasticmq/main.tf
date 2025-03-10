module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

module "elasticmq" {
  source    = "../../modules/generic-deployment-service"
  name      = var.name
  namespace = module.namespace.name
  image     = "softwaremill/elasticmq-native"
  ports_map = { sqs = 9324, ui = 9325 }
}

resource "k8s_networking_k8s_io_v1_ingress" "sqs" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.namespace
    namespace = module.namespace.name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.elasticmq.name
              port {
                number = module.elasticmq.ports.0.port
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

resource "k8s_networking_k8s_io_v1_ingress" "ui" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}-ui.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = "${var.namespace}-ui"
    namespace = module.namespace.name
  }
  spec {
    rules {
      host = "${var.namespace}-ui"
      http {
        paths {
          backend {
            service {
              name = module.elasticmq.name
              port {
                number = module.elasticmq.ports.1.port
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
