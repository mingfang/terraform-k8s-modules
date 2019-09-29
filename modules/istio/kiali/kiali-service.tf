resource "k8s_core_v1_service" "kiali" {
  metadata {
    labels = {
      "app"      = "kiali"
      "chart"    = "kiali"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "kiali"
    namespace = "${var.namespace}"
  }
  spec {

    ports {
      name     = "http-kiali"
      port     = 20001
      protocol = "TCP"
    }
    selector = {
      "app" = "kiali"
    }
  }
}