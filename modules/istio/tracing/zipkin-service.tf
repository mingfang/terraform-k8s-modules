resource "k8s_core_v1_service" "zipkin" {
  metadata {
    labels = {
      "app"      = "jaeger"
      "chart"    = "tracing"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "zipkin"
    namespace = "${var.namespace}"
  }
  spec {

    ports {
      name        = "http"
      port        = 9411
      protocol    = "TCP"
      target_port = "9411"
    }
    selector = {
      "app" = "jaeger"
    }
    type = "ClusterIP"
  }
}