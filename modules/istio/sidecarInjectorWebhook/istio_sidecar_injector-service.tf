resource "k8s_core_v1_service" "istio_sidecar_injector" {
  metadata {
    labels = {
      "app"      = "sidecarInjectorWebhook"
      "chart"    = "sidecarInjectorWebhook"
      "heritage" = "Tiller"
      "istio"    = "sidecar-injector"
      "release"  = "istio"
    }
    name      = "istio-sidecar-injector"
    namespace = var.namespace
  }
  spec {

    ports {
      name        = "https-inject"
      port        = 443
      target_port = "9443"
    }
    ports {
      name = "http-monitoring"
      port = 15014
    }
    selector = {
      "istio" = "sidecar-injector"
    }
  }
}