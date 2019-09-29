resource "k8s_core_v1_service_account" "istio-ingressgateway-service-account" {
  metadata {
    labels = {
      "app"      = "istio-ingressgateway"
      "chart"    = "gateways"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "istio-ingressgateway-service-account"
    namespace = "${var.namespace}"
  }
}