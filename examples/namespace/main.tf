resource "k8s_core_v1_namespace" "this" {
  count = var.is_create ? 1 : 0
  metadata {
    name = var.name
  }
}
