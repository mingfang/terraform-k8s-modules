resource "k8s_core_v1_service" "autoscaler" {
  metadata {
    labels = {
      "app"                         = "autoscaler"
      "serving.knative.dev/release" = "devel"
    }
    name      = "autoscaler"
    namespace = "${var.namespace}"
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
      port        = 9090
      protocol    = "TCP"
      target_port = "9090"
    }
    selector = {
      "app" = "autoscaler"
    }
  }
}