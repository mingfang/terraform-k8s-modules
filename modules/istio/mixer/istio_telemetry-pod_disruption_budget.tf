resource "k8s_policy_v1beta1_pod_disruption_budget" "istio_telemetry" {
  metadata {
    labels = {
      "app"              = "telemetry"
      "chart"            = "mixer"
      "heritage"         = "Tiller"
      "istio"            = "mixer"
      "istio-mixer-type" = "telemetry"
      "release"          = "istio"
      "version"          = "1.5.2"
    }
    name      = "istio-telemetry"
    namespace = var.namespace
  }
  spec {
    min_available = "1"
    selector {
      match_labels = {
        "app"              = "telemetry"
        "istio"            = "mixer"
        "istio-mixer-type" = "telemetry"
        "release"          = "istio"
      }
    }
  }
}