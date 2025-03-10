resource "k8s_core_v1_config_map" "nginx_configuration" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = var.name
      "app.kubernetes.io/part-of" = var.name
    }
    name      = "${var.name}-nginx-configuration"
    namespace = var.namespace
  }

  data = var.config_map_data
}
