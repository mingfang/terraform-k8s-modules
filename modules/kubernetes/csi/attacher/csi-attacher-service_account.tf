resource "k8s_core_v1_service_account" "csi-attacher" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
}