resource "k8s_core_v1_service" "che-host" {
  metadata {
    labels = {
      "app"       = "che"
      "component" = "che"
    }
    name = "che-host"
  }
  spec {

    ports {
      name        = "http"
      port        = 8080
      protocol    = "TCP"
      target_port = "8080"
    }
    ports {
      name        = "metrics"
      port        = 8087
      protocol    = "TCP"
      target_port = "8087"
    }
    selector = {
      "app"       = "che"
      "component" = "che"
    }
  }
}