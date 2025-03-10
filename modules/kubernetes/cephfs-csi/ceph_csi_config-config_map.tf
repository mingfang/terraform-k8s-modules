resource "k8s_core_v1_config_map" "ceph_csi_config" {
  metadata {
    name      = "ceph-csi-config"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  data = {
    "config.json" = var.config_json
  }
}