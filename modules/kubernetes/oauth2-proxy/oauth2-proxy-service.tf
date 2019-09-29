resource "k8s_core_v1_service" "oauth2-proxy" {
  metadata {
    labels = {
      "k8s-app" = var.name
    }
    name      = var.name
    namespace = var.namespace
  }
  spec {

    ports {
      name        = "http"
      port        = 4180
      protocol    = "TCP"
      target_port = "4180"
    }
    selector = {
      "k8s-app" = var.name
    }
  }
}