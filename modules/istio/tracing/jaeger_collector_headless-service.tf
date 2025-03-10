resource "k8s_core_v1_service" "jaeger_collector_headless" {
  metadata {
    labels = {
      "app"          = "jaeger"
      "chart"        = "tracing"
      "heritage"     = "Tiller"
      "jaeger-infra" = "collector-service"
      "release"      = "istio"
    }
    name      = "jaeger-collector-headless"
    namespace = var.namespace
  }
  spec {
    cluster_ip = "None"

    ports {
      name        = "jaeger-collector-grpc"
      port        = 14250
      protocol    = "TCP"
      target_port = "14250"
    }
    selector = {
      "app" = "jaeger"
    }
  }
}