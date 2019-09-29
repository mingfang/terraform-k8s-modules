resource "k8s_core_v1_service_account" "prometheus" {
  metadata {
    labels = {
      "app"      = "prometheus"
      "chart"    = "prometheus"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "prometheus"
    namespace = "${var.namespace}"
  }
}