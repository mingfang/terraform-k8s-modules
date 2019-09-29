resource "k8s_core_v1_service" "prometheus" {
  metadata {
    annotations = {
      "prometheus.io/scrape" = "true"
    }
    labels = {
      "app"      = "prometheus"
      "chart"    = "prometheus"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "prometheus"
    namespace = "${var.namespace}"
  }
  spec {

    ports {
      name     = "http-prometheus"
      port     = 9090
      protocol = "TCP"
    }
    selector = {
      "app" = "prometheus"
    }
  }
}