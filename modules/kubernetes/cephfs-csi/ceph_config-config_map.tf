resource "k8s_core_v1_config_map" "ceph_config" {
  data = {
    "ceph.conf" = <<-EOF
      [global]
      auth_cluster_required = cephx
      auth_service_required = cephx
      auth_client_required = cephx
      EOF
    "keyring"   = ""
  }
  metadata {
    name = "ceph-config"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
}