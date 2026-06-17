module "visas" {
  source    = "../../modules/kogito/jit-runner"
  name      = "visas"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "registry.rebelsoft.com/kogito-visas:latest"

  ports = [
    {
      name = "http"
      port = 8090
    }
  ]

  env = concat(local.env, [
    {
      name  = "KOGITO_SERVICE_URL"
      value = "https://visas-${var.namespace}.rebelsoft.com"
    }
  ])
}

resource "k8s_networking_k8s_io_v1_ingress" "visas" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "visas-${var.namespace}.*"
    }
    name      = module.visas.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = "${module.visas.name}-${var.namespace}"
      http {
        paths {
          backend {
            service {
              name = module.visas.name
              port {
                number = module.visas.ports[0].port
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