resource "k8s_networking_k8s_io_v1_ingress" "kuard" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"       = "nginx"
      "certmanager.k8s.io/cluster-issuer" = "test-selfsigned"
    }
    name = "kuard"
  }
  spec {
    ingress_class_name = "nginx"

    rules {
      host = "kuard.192.168.2.250.nip.io"

      http {

        paths {
          backend {
            service {
              name = kuard
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

    tls {
      hosts = [
        "kuard.192.168.2.250.nip.io"
      ]
      secret_name = "quickstart-example-tls"
    }
  }
}