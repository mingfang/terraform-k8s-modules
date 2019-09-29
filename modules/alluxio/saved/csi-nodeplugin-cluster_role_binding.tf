resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "csi-nodeplugin" {
  metadata {
    name = "csi-nodeplugin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "csi-nodeplugin"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "csi-nodeplugin"
    namespace = var.namespace
  }
}