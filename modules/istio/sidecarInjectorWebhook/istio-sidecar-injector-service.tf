resource "k8s_core_v1_service" "istio-sidecar-injector" {
  metadata {
    labels = {
      "app"      = "sidecarInjectorWebhook"
      "chart"    = "sidecarInjectorWebhook"
      "heritage" = "Tiller"
      "istio"    = "sidecar-injector"
      "release"  = "istio"
    }
    name      = "istio-sidecar-injector"
    namespace = "${var.namespace}"
  }
  spec {

    ports {
      port = 443
    }
    selector = {
      "istio" = "sidecar-injector"
    }
  }
}