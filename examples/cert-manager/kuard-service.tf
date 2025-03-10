resource "k8s_core_v1_service" "kuard" {
  metadata {
    name = "kuard"
  }
  spec {

    ports {
      port        = 80
      protocol    = "TCP"
      target_port = "8080"
    }
    selector = {
      "app" = "kuard"
    }
  }
}