resource "k8s_core_v1_service" "grafana" {
  metadata {
    labels = {
      "app"      = "grafana"
      "chart"    = "grafana"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "grafana"
    namespace = "${var.namespace}"
  }
  spec {

    ports {
      name        = "http"
      port        = 3000
      protocol    = "TCP"
      target_port = "3000"
    }
    selector = {
      "app" = "grafana"
    }
    type = "ClusterIP"
  }
}