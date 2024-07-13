output "namespace" {
  value = k8s_core_v1_namespace.this.metadata[0].name
}

output "provisioner" {
    value = "cephfs.csi.ceph.com"
}