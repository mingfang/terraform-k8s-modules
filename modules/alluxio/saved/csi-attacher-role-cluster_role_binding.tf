resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "csi-attacher-role" {
  metadata {
    name = "csi-attacher-role"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "external-attacher-runner"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "csi-attacher"
    namespace = var.namespace
  }
}