resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "cephfs_csi_nodeplugin" {
  metadata {
    name = "cephfs-csi-nodeplugin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cephfs-csi-nodeplugin"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "cephfs-csi-nodeplugin"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
}