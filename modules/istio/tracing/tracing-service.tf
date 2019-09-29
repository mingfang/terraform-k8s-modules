resource "k8s_core_v1_service" "tracing" {
  metadata {
    labels = {
      "app"      = "jaeger"
      "chart"    = "tracing"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "tracing"
    namespace = "${var.namespace}"
  }
  spec {

    ports {
      name        = "http-query"
      port        = 80
      protocol    = "TCP"
      target_port = "16686"
    }
    selector = {
      "app" = "jaeger"
    }
  }
}