resource "k8s_policy_v1beta1_pod_disruption_budget" "istio_citadel" {
  metadata {
    labels = {
      "app"      = "security"
      "chart"    = "security"
      "heritage" = "Tiller"
      "istio"    = "citadel"
      "release"  = "istio"
    }
    name      = "istio-citadel"
    namespace = var.namespace
  }
  spec {
    min_available = "1"
    selector {
      match_labels = {
        "app"     = "security"
        "istio"   = "citadel"
        "release" = "istio"
      }
    }
  }
}