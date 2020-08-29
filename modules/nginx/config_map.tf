// optional - override nginx.conf and/or default.conf
resource "k8s_core_v1_config_map" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  count = var.nginx-conf != null || var.default-conf != null ? 1 : 0

  data = {
    "nginx.conf"   = var.nginx-conf
    "default.conf" = var.default-conf
  }
}