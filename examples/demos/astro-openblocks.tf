module "astro-openblocks-demo" {
  source    = "../../modules/generic-deployment-service"
  name      = "astro-openblocks-demo"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1
  image = "registry.rebelsoft.com/astro-openblocks-demo:latest"
  ports = [{name="http", port=3000}]
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "astro-openblocks-demo" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "astro-openblocks-demo.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = "astro-openblocks-demo"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "astro-openblocks-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.astro-openblocks-demo.service.metadata[0].name
            service_port = module.astro-openblocks-demo.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
