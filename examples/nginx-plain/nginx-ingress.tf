resource "k8s_extensions_v1beta1_ingress" "nginx" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "nginx.*"
    }
    name      = "nginx"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
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