resource "k8s_core_v1_service" "devfile_registry" {
  metadata {
    labels = {
      "app"       = "che"
      "component" = "devfile-registry"
    }
    name = "devfile-registry"
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
      "component" = "devfile-registry"
    }
  }
}