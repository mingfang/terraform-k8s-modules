resource "k8s_core_v1_config_map" "nginx-configuration" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = var.name
      "app.kubernetes.io/part-of" = var.name
    }
    name      = "${var.name}-nginx-configuration"
    namespace = var.namespace
  }
}