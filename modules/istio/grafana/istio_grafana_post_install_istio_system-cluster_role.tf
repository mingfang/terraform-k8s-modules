resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "istio_grafana_post_install_istio_system" {
  metadata {
    labels = {
      "app"      = "grafana"
      "chart"    = "grafana"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "istio-grafana-post-install-istio-system"
  }

  rules {
    api_groups = [
      "authentication.istio.io",
    ]
    resources = [
      "*",
    ]
    verbs = [
      "*",
    ]
  }
}