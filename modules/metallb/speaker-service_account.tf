resource "k8s_core_v1_service_account" "speaker" {
  metadata {
    labels = {
      "app" = "metallb"
    }
    name      = "speaker"
    namespace = var.namespace
  }
}