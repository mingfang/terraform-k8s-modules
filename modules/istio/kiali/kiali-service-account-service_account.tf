resource "k8s_core_v1_service_account" "kiali-service-account" {
  metadata {
    labels = {
      "app"      = "kiali"
      "chart"    = "kiali"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "kiali-service-account"
    namespace = "${var.namespace}"
  }
}