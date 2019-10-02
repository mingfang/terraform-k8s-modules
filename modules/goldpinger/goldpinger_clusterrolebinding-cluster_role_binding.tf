resource "k8s_rbac_authorization_k8s_io_v1beta1_cluster_role_binding" "goldpinger_clusterrolebinding" {
  metadata {
    name = "${var.namespace}-${var.name}"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "${var.namespace}-${var.name}"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "${var.name}-serviceaccount"
    namespace = "${var.namespace}"
  }
}