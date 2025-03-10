resource "k8s_storage_k8s_io_v1_csi_driver" "cephfs_csi_ceph_com" {
  metadata {
    name = "cephfs.csi.ceph.com"
  }
  spec {
    attach_required  = false
    fsgroup_policy   = "File"
    pod_info_onmount = false
    selinux_mount    = true
  }
}