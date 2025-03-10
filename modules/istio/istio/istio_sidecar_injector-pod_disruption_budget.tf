resource "k8s_policy_v1beta1_pod_disruption_budget" "istio_sidecar_injector" {
  metadata {
    labels = {
      "app"     = "sidecarInjectorWebhook"
      "istio"   = "sidecar-injector"
      "release" = "istio"
    }
    name      = "istio-sidecar-injector"
    namespace = var.namespace
  }
  spec {
    min_available = "1"
    selector {
      match_labels = {
        "app"     = "sidecarInjectorWebhook"
        "istio"   = "sidecar-injector"
        "release" = "istio"
      }
    }
  }
}