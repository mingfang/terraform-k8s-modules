resource "k8s_extensions_v1beta1_ingress" "nginx" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "nginx.*"
    }
    name      = "nginx"
    namespace = var.namespace
  }
  spec {

    rules {
      host = "nginx"
      http {

        paths {
          backend {
            service_name = "nginx"
            service_port = "80"
          }
          path = "/"
        }
      }
    }
  }
}