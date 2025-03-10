resource "k8s_core_v1_service_account" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
  }
}
