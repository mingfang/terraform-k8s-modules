resource "k8s_rbac_authorization_k8s_io_v1_role_binding" "cephfs_csi_provisioner_role_cfg" {
  metadata {
    name      = "cephfs-csi-provisioner-role-cfg"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "cephfs-external-provisioner-cfg"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "cephfs-csi-provisioner"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
}