resource "k8s_core_v1_service" "jaeger_collector" {
  metadata {
    labels = {
      "app"          = "jaeger"
      "chart"        = "tracing"
      "heritage"     = "Tiller"
      "jaeger-infra" = "collector-service"
      "release"      = "istio"
    }
    name      = "jaeger-collector"
    namespace = var.namespace
  }
  spec {

    ports {
      name        = "jaeger-collector-tchannel"
      port        = 14267
      protocol    = "TCP"
      target_port = "14267"
    }
    ports {
      name        = "jaeger-collector-http"
      port        = 14268
      protocol    = "TCP"
      target_port = "14268"
    }
    ports {
      name        = "jaeger-collector-grpc"
      port        = 14250
      protocol    = "TCP"
      target_port = "14250"
    }
    selector = {
      "app" = "jaeger"
    }
    type = "ClusterIP"
  }
}