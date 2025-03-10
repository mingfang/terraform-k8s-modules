resource "k8s_core_v1_service_account" "controller" {
  metadata {
    labels = {
      "app" = "metallb"
    }
    name      = "controller"
    namespace = var.namespace
  }
}