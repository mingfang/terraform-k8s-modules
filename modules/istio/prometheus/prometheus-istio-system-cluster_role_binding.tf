resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "prometheus-istio-system" {
  metadata {
    labels = {
      "app"      = "prometheus"
      "chart"    = "prometheus"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "prometheus-istio-system"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "prometheus-istio-system"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "prometheus"
    namespace = "${var.namespace}"
  }
}