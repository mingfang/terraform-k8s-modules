resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "istio-grafana-post-install-role-binding-istio-system" {
  metadata {
    labels = {
      "app"      = "grafana"
      "chart"    = "grafana"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "istio-grafana-post-install-role-binding-istio-system"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "istio-grafana-post-install-istio-system"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "istio-grafana-post-install-account"
    namespace = "${var.namespace}"
  }
}