resource "k8s_core_v1_service_account" "istio_egressgateway_service_account" {
  metadata {
    labels = {
      "app"      = "istio-egressgateway"
      "chart"    = "gateways"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "istio-egressgateway-service-account"
    namespace = var.namespace
  }
}