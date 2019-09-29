resource "k8s_core_v1_service_account" "istio-sidecar-injector-service-account" {
  metadata {
    labels = {
      "app"      = "sidecarInjectorWebhook"
      "chart"    = "sidecarInjectorWebhook"
      "heritage" = "Tiller"
      "istio"    = "sidecar-injector"
      "release"  = "istio"
    }
    name      = "istio-sidecar-injector-service-account"
    namespace = "${var.namespace}"
  }
}