// optional - override default.conf
resource "k8s_core_v1_config_map" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  count = var.default-conf == null ? 0 : 1

  data = {
    "default.conf" = var.default-conf
  }
}