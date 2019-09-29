resource "k8s_policy_v1beta1_pod_disruption_budget" "istio-galley" {
  metadata {
    labels = {
      "app"      = "galley"
      "chart"    = "galley"
      "heritage" = "Tiller"
      "istio"    = "galley"
      "release"  = "istio"
    }
    name      = "istio-galley"
    namespace = "${var.namespace}"
  }
  spec {
    min_available = "1"
    selector {
      match_labels = {
        "app"     = "galley"
        "istio"   = "galley"
        "release" = "istio"
      }
    }
  }
}