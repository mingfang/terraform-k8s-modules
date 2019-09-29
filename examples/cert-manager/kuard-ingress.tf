resource "k8s_extensions_v1beta1_ingress" "kuard" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "certmanager.k8s.io/cluster-issuer" = "test-selfsigned"
    }
    name = "kuard"
  }
  spec {

    rules {
      host = "kuard.192.168.2.250.nip.io"

      http {

        paths {
          backend {
            service_name = "kuard"
            service_port = "80"
          }
          path = "/"
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