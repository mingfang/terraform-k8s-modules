resource "k8s_core_v1_service" "goldpinger" {
  metadata {
    labels = {
      "app" = "${var.name}"
    }
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }
  spec {

    ports {
      name = "http"
      port = 80
    }
    selector = {
      "app" = "${var.name}"
    }

  }
}