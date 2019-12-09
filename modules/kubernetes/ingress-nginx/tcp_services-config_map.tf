resource "k8s_core_v1_config_map" "tcp-services" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = var.name
      "app.kubernetes.io/part-of" = var.name
    }
    name      = "${var.name}-tcp-services"
    namespace = var.namespace
  }

  data = var.tcp_services_data
}