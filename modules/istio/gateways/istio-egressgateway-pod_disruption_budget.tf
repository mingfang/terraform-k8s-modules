resource "k8s_policy_v1beta1_pod_disruption_budget" "istio-egressgateway" {
  metadata {
    labels = {
      "app"      = "istio-egressgateway"
      "chart"    = "gateways"
      "heritage" = "Tiller"
      "istio"    = "egressgateway"
      "release"  = "istio"
    }
    name      = "istio-egressgateway"
    namespace = "${var.namespace}"
  }
  spec {
    min_available = "1"
    selector {
      match_labels = {
        "app"     = "istio-egressgateway"
        "istio"   = "egressgateway"
        "release" = "istio"
      }
    }
  }
}