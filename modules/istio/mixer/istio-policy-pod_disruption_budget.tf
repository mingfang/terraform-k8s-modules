resource "k8s_policy_v1beta1_pod_disruption_budget" "istio-policy" {
  metadata {
    labels = {
      "app"              = "policy"
      "chart"            = "mixer"
      "heritage"         = "Tiller"
      "istio"            = "mixer"
      "istio-mixer-type" = "policy"
      "release"          = "istio"
      "version"          = "1.1.0"
    }
    name      = "istio-policy"
    namespace = "${var.namespace}"
  }
  spec {
    min_available = "1"
    selector {
      match_labels = {
        "app"              = "policy"
        "istio"            = "mixer"
        "istio-mixer-type" = "policy"
        "release"          = "istio"
      }
    }
  }
}