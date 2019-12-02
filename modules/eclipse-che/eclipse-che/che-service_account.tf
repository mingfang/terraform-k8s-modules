resource "k8s_core_v1_service_account" "che" {
  metadata {
    labels = {
      "app"       = "che"
      "component" = "che"
    }
    name = "che"
    namespace = var.namespace
  }
}