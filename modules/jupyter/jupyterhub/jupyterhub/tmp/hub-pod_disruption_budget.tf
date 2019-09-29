resource "k8s_policy_v1beta1_pod_disruption_budget" "hub" {
  metadata {
    labels = {
      "app"       = "jupyterhub"
      "chart"     = "jupyterhub-0.8.2"
      "component" = "hub"
      "heritage"  = "Helm"
      "release"   = "RELEASE-NAME"
    }
    name = "hub"
  }
  spec {
    min_available = "1"
    selector {
      match_labels = {
        "app"       = "jupyterhub"
        "component" = "hub"
        "release"   = "RELEASE-NAME"
      }
    }
  }
}