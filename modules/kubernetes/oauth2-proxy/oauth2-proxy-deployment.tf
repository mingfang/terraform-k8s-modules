resource "k8s_apps_v1_deployment" "oauth2-proxy" {
  metadata {
    labels = {
      "k8s-app" = var.name
    }
    name      = var.name
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "k8s-app" = var.name
      }
    }
    template {
      metadata {
        labels = {
          "k8s-app" = var.name
        }
      }
      spec {

        containers {
          args = [
            "--provider=github",
            "--email-domain=*",
            "--upstream=file:///dev/null",
            "--http-address=0.0.0.0:4180",
            "--cookie-domain=${var.cookie_domain}"
          ]

          env {
            name  = "OAUTH2_PROXY_CLIENT_ID"
            value = var.OAUTH2_PROXY_CLIENT_ID
          }
          env {
            name  = "OAUTH2_PROXY_CLIENT_SECRET"
            value = var.OAUTH2_PROXY_CLIENT_SECRET
          }
          env {
            name  = "OAUTH2_PROXY_COOKIE_SECRET"
            value = var.OAUTH2_PROXY_COOKIE_SECRET
          }
          image             = "quay.io/pusher/oauth2_proxy:latest"
          image_pull_policy = "Always"
          name              = var.name

          ports {
            container_port = 4180
            protocol       = "TCP"
          }
        }
      }
    }
  }
}