resource "k8s_core_v1_service_account" "cephfs_csi_nodeplugin" {
  metadata {
    name      = "cephfs-csi-nodeplugin"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
}