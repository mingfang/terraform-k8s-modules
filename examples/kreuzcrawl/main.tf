module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

module "kreuzcrawl" {
  source    = "../../modules/generic-deployment-service"
  name      = var.name
  namespace = module.namespace.name
  image     = "ghcr.io/kreuzberg-dev/kreuzcrawl:latest"
  ports_map = { http = 3000 }

  args = ["serve"]

  liveness_probe = {
    initial_delay_seconds = 30
    period_seconds        = 30
    failure_threshold     = 3

    http_get = {
      path = "/health"
      port = 3000
    }
  }
}

resource "k8s_networking_k8s_io_v1_ingress" "this" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.namespace
    namespace = module.namespace.name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.kreuzcrawl.name
              port {
                number = module.kreuzcrawl.ports_map.http
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
