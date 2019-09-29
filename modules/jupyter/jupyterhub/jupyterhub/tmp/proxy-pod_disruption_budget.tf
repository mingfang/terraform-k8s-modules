resource "k8s_policy_v1beta1_pod_disruption_budget" "proxy" {
  metadata {
    labels = {
      "app"       = "jupyterhub"
      "chart"     = "jupyterhub-0.8.2"
      "component" = "proxy"
      "heritage"  = "Helm"
      "release"   = "RELEASE-NAME"
    }
    name = "proxy"
  }
  spec {
    min_available = "1"
    selector {
      match_labels = {
        "app"       = "jupyterhub"
        "component" = "proxy"
        "release"   = "RELEASE-NAME"
      }
    }
  }
}