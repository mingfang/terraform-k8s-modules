resource "k8s_core_v1_service" "activator-service" {
  metadata {
    labels = {
      "app"                         = "activator"
      "serving.knative.dev/release" = "devel"
    }
    name      = "activator-service"
    namespace = "${var.namespace}"
  }
  spec {

    ports {
      name        = "http"
      port        = 80
      protocol    = "TCP"
      target_port = "8080"
    }
    ports {
      name        = "http2"
      port        = 81
      protocol    = "TCP"
      target_port = "8081"
    }
    ports {
      name        = "metrics"
      port        = 9090
      protocol    = "TCP"
      target_port = "9090"
    }
    selector = {
      "app" = "activator"
    }
    type = "ClusterIP"
  }
}