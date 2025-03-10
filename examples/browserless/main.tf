resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "browserless" {
  source    = "../../modules/browserless"
  name      = "browserless"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env_map = {
    WORKSPACE_EXPIRE_DAYS    = "1"
    WORKSPACE_DELETE_EXPIRED = "true"
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "browserless" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.browserless.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.browserless.name
            service_port = module.browserless.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
