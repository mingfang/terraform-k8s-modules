resource "k8s_core_v1_service" "controller" {
  metadata {
    labels = {
      "app"                         = "controller"
      "serving.knative.dev/release" = "devel"
    }
    name      = "controller"
    namespace = "${var.namespace}"
  }
  spec {

    ports {
      name        = "metrics"
      port        = 9090
      protocol    = "TCP"
      target_port = "9090"
    }
    selector = {
      "app" = "controller"
    }
  }
}