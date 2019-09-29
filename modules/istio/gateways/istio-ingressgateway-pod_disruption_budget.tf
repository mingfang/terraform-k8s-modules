resource "k8s_policy_v1beta1_pod_disruption_budget" "istio-ingressgateway" {
  metadata {
    labels = {
      "app"      = "istio-ingressgateway"
      "chart"    = "gateways"
      "heritage" = "Tiller"
      "istio"    = "ingressgateway"
      "release"  = "istio"
    }
    name      = "istio-ingressgateway"
    namespace = "${var.namespace}"
  }
  spec {
    min_available = "1"
    selector {
      match_labels = {
        "app"     = "istio-ingressgateway"
        "istio"   = "ingressgateway"
        "release" = "istio"
      }
    }
  }
}