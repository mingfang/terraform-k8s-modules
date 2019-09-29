resource "k8s_core_v1_service" "jaeger-agent" {
  metadata {
    labels = {
      "app"          = "jaeger"
      "chart"        = "tracing"
      "heritage"     = "Tiller"
      "jaeger-infra" = "agent-service"
      "release"      = "istio"
    }
    name      = "jaeger-agent"
    namespace = "${var.namespace}"
  }
  spec {
    cluster_ip = "None"

    ports {
      name        = "agent-zipkin-thrift"
      port        = 5775
      protocol    = "UDP"
      target_port = "5775"
    }
    ports {
      name        = "agent-compact"
      port        = 6831
      protocol    = "UDP"
      target_port = "6831"
    }
    ports {
      name        = "agent-binary"
      port        = 6832
      protocol    = "UDP"
      target_port = "6832"
    }
    selector = {
      "app" = "jaeger"
    }
  }
}