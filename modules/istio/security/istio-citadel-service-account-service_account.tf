resource "k8s_core_v1_service_account" "istio-citadel-service-account" {
  metadata {
    labels = {
      "app"      = "security"
      "chart"    = "security"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "istio-citadel-service-account"
    namespace = "${var.namespace}"
  }
}