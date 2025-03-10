module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

module "jaeger" {
  source    = "../../modules/generic-deployment-service"
  name      = var.name
  namespace = module.namespace.name
  image     = "jaegertracing/jaeger:2.3.0"
  ports = [
    { name = "tcp1", port = 16686 },
    { name = "tcp2", port = 4317 },
    { name = "tcp3", port = 4318 },
  ]

  env_map = {
    COLLECTOR_OTLP_ENABLED = "true"
  }
}

resource "k8s_networking_k8s_io_v1_ingress" "jaeger" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
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
              name = module.jaeger.name
              port {
                number = module.jaeger.ports[0].port
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
