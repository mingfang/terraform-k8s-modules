resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}