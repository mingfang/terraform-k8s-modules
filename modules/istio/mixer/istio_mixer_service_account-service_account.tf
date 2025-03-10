resource "k8s_core_v1_service_account" "istio_mixer_service_account" {
  metadata {
    labels = {
      "app"      = "mixer"
      "chart"    = "mixer"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "istio-mixer-service-account"
    namespace = var.namespace
  }
}