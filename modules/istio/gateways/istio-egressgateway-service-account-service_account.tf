resource "k8s_core_v1_service_account" "istio-egressgateway-service-account" {
  metadata {
    labels = {
      "app"      = "istio-egressgateway"
      "chart"    = "gateways"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "istio-egressgateway-service-account"
    namespace = "${var.namespace}"
  }
}