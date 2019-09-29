resource "k8s_policy_v1beta1_pod_disruption_budget" "user_scheduler" {
  metadata {
    labels = {
      "app"       = "jupyterhub"
      "chart"     = "jupyterhub-0.8.2"
      "component" = "user-scheduler"
      "heritage"  = "Helm"
      "release"   = "RELEASE-NAME"
    }
    name = "user-scheduler"
  }
  spec {
    min_available = "1"
    selector {
      match_labels = {
        "app"       = "jupyterhub"
        "component" = "user-scheduler"
        "release"   = "RELEASE-NAME"
      }
    }
  }
}