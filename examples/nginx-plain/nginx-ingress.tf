resource "k8s_networking_k8s_io_v1_ingress" "nginx" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "nginx.*"
    }
    name      = "nginx"
    namespace = var.namespace
  }
  spec {
    ingress_class_name = "nginx"

    rules {
      host = "nginx"
      http {

        paths {
          backend {
            service {
              name = nginx
              port {
                number = "80"
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