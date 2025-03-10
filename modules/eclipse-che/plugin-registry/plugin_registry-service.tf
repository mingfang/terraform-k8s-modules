resource "k8s_core_v1_service" "plugin_registry" {
  metadata {
    labels = {
      "app"       = "che"
      "component" = "plugin-registry"
    }
    name = "plugin-registry"
    namespace = var.namespace
  }
  spec {

    ports {
      port        = 8080
      protocol    = "TCP"
      target_port = "8080"
    }
    selector = {
      "app"       = "che"
      "component" = "plugin-registry"
    }
  }
}