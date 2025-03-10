module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

module "hugegraph" {
  source    = "../../modules/generic-deployment-service"
  name      = var.name
  namespace = module.namespace.name
  image     = "hugegraph/hugegraph:latest"
  ports     = [{name = "tcp", port = 8080}]

  env_map = {
    "PRELOAD"="true"
  }
}

resource "k8s_networking_k8s_io_v1_ingress" "hugegraph" {
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
              name = module.hugegraph.name
              port {
                number = module.hugegraph.ports.0.port
              }
            }
          }
          path = "/"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}

module "hubble" {
  source    = "../../modules/generic-deployment-service"
  name      = "hubble"
  namespace = module.namespace.name
  image     = "hugegraph/hubble:latest"
  ports     = [{name = "tcp", port = 8088}]
  command   = []
  args   = []
}

resource "k8s_networking_k8s_io_v1_ingress" "hubble" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "hubble-${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = "hubble-${var.namespace}"
    namespace = module.namespace.name
  }
  spec {
    rules {
      host = "hubble-${var.namespace}"
      http {
        paths {
          backend {
            service {
              name = module.hubble.name
              port {
                number = module.hubble.ports.0.port
              }
            }
          }
          path = "/"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}
