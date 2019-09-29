resource "k8s_core_v1_service" "jaeger-query" {
  metadata {
    labels = {
      "app"          = "jaeger"
      "chart"        = "tracing"
      "heritage"     = "Tiller"
      "jaeger-infra" = "jaeger-service"
      "release"      = "istio"
    }
    name      = "jaeger-query"
    namespace = "${var.namespace}"
  }
  spec {

    ports {
      name        = "query-http"
      port        = 16686
      protocol    = "TCP"
      target_port = "16686"
    }
    selector = {
      "app" = "jaeger"
    }
  }
}