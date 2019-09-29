resource "k8s_cert_manager_io_v1alpha2_issuer" "letsencrypt-prod" {
  metadata {
    name = "letsencrypt-prod"
  }
  spec {
    acme {
      email = "user@example.com"
      private_key_secret_ref {
        name = "letsencrypt-prod"
      }
      server = "https://acme-v02.api.letsencrypt.org/directory"
        solvers {
          http01 {
            ingress {
              class = "nginx"
            }
          }
        }
    }
  }
}