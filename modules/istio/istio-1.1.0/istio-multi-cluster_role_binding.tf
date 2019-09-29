resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "istio-multi" {
  metadata {
    labels = {
      "chart" = "istio-1.1.0"
    }
    name = "istio-multi"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "istio-reader"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "istio-multi"
    namespace = "${var.namespace}"
  }
}