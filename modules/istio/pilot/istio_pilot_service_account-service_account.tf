resource "k8s_core_v1_service_account" "istio_pilot_service_account" {
  metadata {
    labels = {
      "app"      = "pilot"
      "chart"    = "pilot"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "istio-pilot-service-account"
    namespace = var.namespace
  }
}