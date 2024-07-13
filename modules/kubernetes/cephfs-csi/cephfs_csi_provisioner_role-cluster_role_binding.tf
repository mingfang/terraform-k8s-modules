resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "cephfs_csi_provisioner_role" {
  metadata {
    name = "cephfs-csi-provisioner-role"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cephfs-external-provisioner-runner"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "cephfs-csi-provisioner"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
}