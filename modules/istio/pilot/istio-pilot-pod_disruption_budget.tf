resource "k8s_policy_v1beta1_pod_disruption_budget" "istio-pilot" {
  metadata {
    labels = {
      "app"      = "pilot"
      "chart"    = "pilot"
      "heritage" = "Tiller"
      "istio"    = "pilot"
      "release"  = "istio"
    }
    name      = "istio-pilot"
    namespace = "${var.namespace}"
  }
  spec {
    min_available = "1"
    selector {
      match_labels = {
        "app"     = "pilot"
        "istio"   = "pilot"
        "release" = "istio"
      }
    }
  }
}