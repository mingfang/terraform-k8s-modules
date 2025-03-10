resource "k8s_cert_manager_io_v1alpha2_issuer" "letsencrypt-staging" {
  metadata {
    name = "letsencrypt-staging"
  }
  spec {
    acme {
      email = "user@example.com"
      private_key_secret_ref {
        name = "letsencrypt-staging"
      }
      server = "https://acme-staging-v02.api.letsencrypt.org/directory"
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