resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "csi-attacher-role" {
  metadata {
    name = "${var.name}-role"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "${var.name}-runner"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = var.name
    namespace = var.namespace
  }
}